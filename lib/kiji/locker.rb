module Kiji
  class Locker
    def initialize(lockfile='status.lock')
      @lockfile = lockfile
    end

    def create
      File.open(@lockfile, 'a') {|f| f.write("Lock file last written: #{Time.now}\n")}
    end

    def exists?
      File.exist? @lockfile
    end

    def destroy
      File.delete @lockfile
    end
  end
end