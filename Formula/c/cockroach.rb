class Cockroach < Formula
  desc "Distributed SQL database"
  homepage "https://www.cockroachlabs.com"
  url "https://binaries.cockroachdb.com/cockroach-v19.1.5.src.tgz"
  sha256 "1e3329a56e5a1729ed3ac4ff0a97943163325dd4825e8c7c8c1d9fd57bfddfde"
  license "Apache-2.0"
  head "https://github.com/cockroachdb/cockroach.git", branch: "master"

  depends_on "autoconf" => :build
  depends_on "cmake" => :build
  depends_on "go" => :build
  depends_on "make" => :build
  depends_on "xz" => :build

  def install
    # The GNU Make that ships with macOS Mojave (v3.81 at the time of writing) has a bug
    # that causes it to loop infinitely when trying to build cockroach. Use
    # the more up-to-date make that Homebrew provides.
    ENV.prepend_path "PATH", Formula["make"].opt_libexec/"gnubin"

    # Patch the CXX_FLAGS used to build rocksdb as a workaround for the issue fixed by
    # https://github.com/facebook/rocksdb/pull/5779. Furthermore on 10.14 (Mojave) and
    # later we also allow defaulted-function-delete as a workaround for
    # https://github.com/facebook/rocksdb/pull/5095.
    if !OS.mac? || MacOS.version < "10.14"
      patch = <<~PATCH
        253c253
        <     set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Werror")
        ---
        >     set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Werror -Wno-error=shadow")
      PATCH
    else
      patch = <<~PATCH
        253c253
        <     set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Werror")
        ---
        >     set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Werror -Wno-error=shadow -Wno-error=defaulted-function-deleted")
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

    # Ensure that go modules are not used as cockroachdb does not support them.
    ENV["GO111MODULE"] = "off"

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
    # Redirect stdout and stderr to a file, or else  `brew test --verbose`
    # will hang forever as it waits for stdout and stderr to close.
    system "#{bin}/cockroach start --insecure --background &> start.out"
    pipe_output("#{bin}/cockroach sql --insecure", <<~EOS)
      CREATE DATABASE bank;
      CREATE TABLE bank.accounts (id INT PRIMARY KEY, balance DECIMAL);
      INSERT INTO bank.accounts VALUES (1, 1000.50);
    EOS
    output = pipe_output("#{bin}/cockroach sql --insecure --format=csv",
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
    system bin/"cockroach", "quit", "--insecure"
  end
end
