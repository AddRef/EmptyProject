from os import listdir
import os.path
import shutil
import datetime
from zipfile import ZipFile
import xml.etree.ElementTree as etree

#unpack only boost for specific platform
#rm folder which should be replaces with unpacked one

class UnpackConfig:
    """Filters list of files based on unpack_config.xml"""
    def __init__(self, unpack_config_name):
        # Build list of files to unpack
        self._filters = []
        tree = etree.parse('unpack_config.xml')
        # Read common section of filter file
        common_config = tree.find('common')
        for module in common_config:
            self._filters.append(module.tag)
        # Read OS specific part of filter file
        linux_config = tree.find('mac')
        for module in linux_config:
            self._filters.append(module.tag)

    def needs_process(self, file_name):
        # Do not process files that are missing in filter list
        if not file_name in self._filters:
            return False
        return True


class FilesCache:
    """Provices check if particular file has changed since last usage"""
    def __init__(self, cache_file_name):
        # Read file with timestamps of file modifications to check with
        self._cache_file_name = cache_file_name
        self._cache = self._load_cache(self._cache_file_name)

    def has_changed(self, file_name):
        timestamp = self._get_file_timestamp(file_name)
        # Do not process files/folders that havn't been mosidifed
        if file_name in self._cache and self._cache[file_name] == timestamp:
            return False        
        self._cache[file_name] = timestamp
        return True

    def update_file(self, file_name):
        self._cache[file_name] = self._get_file_timestamp(file_name)

    def flush(self):
        self._store_cache(self._cache, self._cache_file_name)

    def _get_file_timestamp(self, file_name):
        t = os.path.getmtime(file_name)
        timestamp = ('%s') % datetime.datetime.fromtimestamp(t)
        timestamp = timestamp.strip()
        return timestamp

    def _load_cache(self, cache_file_name):
        filters = {}
        if os.path.exists(self._cache_file_name):
            f = open(self._cache_file_name, 'r')
            for line in f.readlines():
                (file_name, file_creation_date) = line.split(',')
                file_name = file_name.strip()
                file_creation_date = file_creation_date.strip()
                filters[file_name] = file_creation_date
            f.close()
        return filters

    def _store_cache(self, filters, cache_file_name):
        f = open(self._cache_file_name, 'w+')
        for (file_name, file_creation_date) in filters.iteritems():
            str = "%s,%s\n" % (file_name, file_creation_date)
            f.write(str)
        f.close()


class Unpacker:
    """Unpacks zip archives located in current folder"""
    def __init__(self):
        self._file_cache_file_path = "./file_cache"
        self._config_file_path = "./unpack_config.xml"
        self._files_cache = FilesCache(self._file_cache_file_path)
        self._unpack_config = UnpackConfig(self._config_file_path)
        self._path = './'
        self._unpack_folder = './_unpack'

    def unpack(self):
        """unpacks path set in class constructor"""
        for f in listdir(self._path):
            self._process_file(f)
        self._files_cache.flush()

    def _process_file(self, file_name):
        full_file_path = os.path.join(self._path, file_name)
        if (os.path.isfile(full_file_path)):
            name, ext = os.path.splitext(file_name)
            if (ext == '.zip' and self._unpack_config.needs_process(name)):
                # check if zip has modified recently
                unpack_zip_path = os.path.join(self._unpack_folder, name)
                unpack_zip_exists = os.path.exists(unpack_zip_path)
                # Check if either source zip or destination folder has changed
                zip_changed = self._files_cache.has_changed(full_file_path)
                unpack_zip_changed = unpack_zip_exists and self._files_cache.has_changed(unpack_zip_path)
                if zip_changed or not unpack_zip_exists or unpack_zip_changed:
                    self._remove_file(unpack_zip_path)
                    self._unzip(file_name, self._unpack_folder)
                    # after unpack update timestamp for unpack folder in files cache
                    self._files_cache.update_file(unpack_zip_path)
                else:
                    print "Skipping file %s: it was already unpacked" % (file_name)

    def _remove_file(self, path):
        """removes file or folder recursively"""
        if (os.path.exists(path)):
            shutil.rmtree(path, ignore_errors=True)


    def _unzip(self, file, out_folder):
        print "Extracting %s..." % (file)
        zfile = ZipFile(file)
        # Add zip name to output path so every zip is extracted into
        # separate folder having the same name as an archive
        zip_name, _ = os.path.splitext(file)
        out_folder = os.path.join(out_folder, zip_name)
        for name in zfile.namelist():
            dir_name, file_name = os.path.split(name)
            # create directory for current file in archive
            new_dir = os.path.join(out_folder, dir_name)
            if not os.path.exists(new_dir):
                os.makedirs(new_dir)
            # and finaly write a file
            if file_name:
                fd = open(os.path.join(out_folder, name), 'wb')
                fd.write(zfile.read(name))
                fd.close()
        zfile.close()
        print "Extracting %s... DONE" % (file)


#if __name__ == '__main__':
unpacker = Unpacker()
unpacker.unpack()
