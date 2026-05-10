class Cockroach < Formula
  desc "Distributed SQL database"
  homepage "https://www.cockroachlabs.com"
  url "https://binaries.cockroachdb.com/cockroach-v19.1.5.src.tgz"
  sha256 "1e3329a56e5a1729ed3ac4ff0a97943163325dd4825e8c7c8c1d9fd57bfddfde"
  license "Apache-2.0"
  head "https://github.com/cockroachdb/cockroach.git", branch: "master"

  depends_on "autoconf" => :build
  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "go" => :build
  depends_on "make" => :build
  depends_on "xz" => :build

  on_linux do
    depends_on arch: :x86_64 # Cockroach 19.1 vendored Kerberos does not configure on Linux ARM
    depends_on "ncurses"
  end

  def install
    # The GNU Make that ships with macOS Mojave (v3.81 at the time of writing) has a bug
    # that causes it to loop infinitely when trying to build cockroach. Use
    # the more up-to-date make that Homebrew provides.
    ENV.prepend_path "PATH", Formula["make"].opt_libexec/"gnubin"
    ENV["YACC"] = "#{Formula["bison"].opt_bin/"bison"} -y"
    ENV.append_to_cflags "-fcommon" if OS.linux?

    # Patch the CXX_FLAGS used to build rocksdb as a workaround for the issue fixed by
    # https://github.com/facebook/rocksdb/pull/5779. Furthermore on 10.14 (Mojave) and
    # later we also allow defaulted-function-delete as a workaround for
    # https://github.com/facebook/rocksdb/pull/5095.
    if !OS.mac? || MacOS.version < "10.14"
      patch = <<~PATCH
        253c253
        <     set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Werror")
        ---
        >     set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Werror -Wno-error=shadow -Wno-error=unused-but-set-variable -Wno-error=unused-function")
      PATCH
    else
      patch = <<~PATCH
        253c253
        <     set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Werror")
        ---
        >     set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Werror -Wno-error=shadow -Wno-error=defaulted-function-deleted -Wno-error=deprecated-copy-with-user-provided-copy -Wno-error=unused-but-set-variable -Wno-error=unused-function")
      PATCH
    end
    patchfile = Tempfile.new("patch")
    begin
      patchfile.write(patch)
      patchfile.close
      system "patch", "src/github.com/cockroachdb/cockroach/c-deps/rocksdb/CMakeLists.txt", patchfile.path
    ensure
      patchfile.unlink
    end

    inreplace "src/github.com/cockroachdb/cockroach/c-deps/protobuf/cmake/CMakeLists.txt",
              "cmake_minimum_required(VERSION 3.1.3)",
              "cmake_minimum_required(VERSION 3.5)"
    inreplace "src/github.com/cockroachdb/cockroach/c-deps/snappy/CMakeLists.txt",
              "cmake_minimum_required(VERSION 3.1)",
              "cmake_minimum_required(VERSION 3.5)"
    inreplace "src/github.com/cockroachdb/cockroach/c-deps/rocksdb/CMakeLists.txt",
              "cmake_minimum_required(VERSION 2.8.12)",
              "cmake_minimum_required(VERSION 3.5)"
    inreplace "src/github.com/cockroachdb/cockroach/c-deps/libroach/CMakeLists.txt",
              "cmake_minimum_required(VERSION 3.3 FATAL_ERROR)",
              "cmake_minimum_required(VERSION 3.5)"
    inreplace "src/github.com/cockroachdb/cockroach/c-deps/googletest/googletest/CMakeLists.txt",
              "cmake_minimum_required(VERSION 2.6.4)",
              "cmake_minimum_required(VERSION 3.5)"
    inreplace "src/github.com/cockroachdb/cockroach/c-deps/cryptopp/CMakeLists.txt",
              "cmake_minimum_required(VERSION 2.8.5 FATAL_ERROR)",
              "cmake_minimum_required(VERSION 3.5)"
    inreplace "src/github.com/cockroachdb/cockroach/vendor/github.com/knz/strtime/bsdshim.h",
              "#include <time.h>\n\n#define locale_t int",
              "#include <time.h>\n#include <locale.h>\n\n#define locale_t int"
    inreplace "src/github.com/cockroachdb/cockroach/vendor/github.com/knz/strtime/gmtime_r.c",
              "static void\ntimesub(timep, offset, tmp)\nconst time_t * const\t\t\ttimep;\n" \
              "const long\t\t\t\toffset;\nstruct mytm * const\t\ttmp;\n{\n",
              "static void\ntimesub(const time_t * const timep, const long offset, struct mytm * const tmp)\n{\n"
    syscall_glob = "src/github.com/cockroachdb/cockroach/vendor/golang.org/x/sys/unix/" \
                   "zsyscall_darwin_*.go"
    linkname_re = %r{
      ^func\ (libc_\w+)_trampoline\(\)\n\n
      //go:linkname\ [^\n]+\n
      (//go:cgo_import_dynamic\ [^\n]+)
    }x
    Pathname.glob(syscall_glob).each do |syscall_file|
      inreplace syscall_file do |s|
        s.gsub!(/funcPC\((libc_\w+)_trampoline\)/, "\\1_trampoline_addr", audit_result: false)
        s.gsub!(linkname_re, "var \\1_trampoline_addr uintptr\n\n\\2", audit_result: false)
      end
    end
    inreplace "src/github.com/cockroachdb/cockroach/c-deps/krb5/src/aclocal.m4",
              "if test -d \"$srcdir/$ac_config_fragdir\"; then\n  AC_CONFIG_AUX_DIR(K5_TOPDIR/config)",
              "if test -d \"$srcdir/$ac_config_fragdir\"; then\n  :\n  AC_CONFIG_AUX_DIR(K5_TOPDIR/config)"
    inreplace "src/github.com/cockroachdb/cockroach/c-deps/krb5/src/aclocal.m4",
              "],krb5_cv_inet6=yes,krb5_cv_inet6=no)])\nfi",
              "],krb5_cv_inet6=yes,krb5_cv_inet6=no)\nfi])"
    inreplace "src/github.com/cockroachdb/cockroach/Makefile",
              "cd $(KRB5_SRC_DIR)/src && autoreconf",
              "cd $(KRB5_SRC_DIR)/src && autoheader configure.in && autoconf -o configure configure.in"
    if OS.linux?
      inreplace "src/github.com/cockroachdb/cockroach/Makefile",
                "cd $(KRB5_DIR) && env -u CFLAGS -u CXXFLAGS $(KRB5_SRC_DIR)/src/configure " \
                "$(xconfigure-flags) --enable-static --disable-shared",
                "cd $(KRB5_DIR) && env -u CXXFLAGS CFLAGS=\"-g -O2 -fcommon\" " \
                "$(KRB5_SRC_DIR)/src/configure $(xconfigure-flags) --enable-static --disable-shared"
    end
    inreplace "src/github.com/cockroachdb/cockroach/Makefile",
              'cd $(CRYPTOPP_DIR) && CFLAGS+=" $(aes)" && CXXFLAGS+=" $(aes)" cmake',
              'cd $(CRYPTOPP_DIR) && CFLAGS+=" $(aes)" && CXXFLAGS+=" $(aes) -std=c++14" cmake'

    # Ensure that go modules are not used as cockroachdb does not support them.
    ENV["GO111MODULE"] = "off"
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    # Build only the OSS components
    system "make", "buildoss"
    system "make", "install", "prefix=#{prefix}", "BUILDTYPE=release"
  end

  def caveats
    <<~EOS
      For local development only, this formula ships a launchd configuration to
      start a single-node cluster that stores its data under:
        #{var}/cockroach/
      Instead of the default port of 8080, the node serves its admin UI at:
        #{Formatter.url("http://localhost:26256")}

      Do NOT use this cluster to store data you care about; it runs in insecure
      mode and may expose data publicly in e.g. a DNS rebinding attack. To run
      CockroachDB securely, please see:
        #{Formatter.url("https://www.cockroachlabs.com/docs/secure-a-cluster.html")}

      Due to a license change, the cockroach package in homebrew-core will no
      longer be updated when CockroachDB 19.2 is released. Please switch to
      https://github.com/cockroachdb/homebrew-tap instead.
    EOS
  end

  service do
    run [
      opt_bin/"cockroach",
      "start",
      "--store=#{var}/cockroach/",
      "--http-port=26256",
      "--insecure",
      "--host=localhost",
    ]
    working_dir var
    keep_alive true
  end

  test do
    port = free_port
    http_port = free_port

    # Redirect stdout and stderr to a file, or else  `brew test --verbose`
    # will hang forever as it waits for stdout and stderr to close.
    system "#{bin}/cockroach start --insecure --listen-addr=localhost:#{port} " \
           "--http-addr=localhost:#{http_port} --store=#{testpath}/store --background > start.out 2>&1"
    pipe_output("#{bin}/cockroach sql --insecure --host=localhost:#{port}", <<~EOS)
      CREATE DATABASE bank;
      CREATE TABLE bank.accounts (id INT PRIMARY KEY, balance DECIMAL);
      INSERT INTO bank.accounts VALUES (1, 1000.50);
    EOS
    output = pipe_output("#{bin}/cockroach sql --insecure --host=localhost:#{port} --format=csv",
      "SELECT * FROM bank.accounts;")
    assert_equal <<~EOS, output
      id,balance
      1,1000.50
    EOS
  rescue => e
    # If an error occurs, attempt to print out any messages from the
    # server.
    begin
      $stderr.puts "server messages:", File.read("start.out")
    rescue
      $stderr.puts "unable to load messages from start.out"
    end
    raise e
  ensure
    system bin/"cockroach", "quit", "--insecure", "--host=localhost:#{port}" if port
  end
end
