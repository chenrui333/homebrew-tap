class Agentty < Formula
  desc "Terminal AI pair programmer written in modern C++"
  homepage "https://github.com/agentty-org/agentty"
  url "https://github.com/agentty-org/agentty.git",
      tag:      "v0.9.65",
      revision: "ee20610564790e996265cb373c22133261741f61"
  license "MIT"
  head "https://github.com/agentty-org/agentty.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "635b47f187d1e41d87dd9115f3ee8b22d1cf4b3075184a37f1cba7a06a35ea74"
    sha256               arm64_tahoe:   "2e04b6c7a4cca62b474c401c1ac99e5c1f8f7bf79a05ef0a5168e38bc43cc1f8"
    sha256               arm64_sequoia: "e7e6d807486883f8aee0ad09c0a50d5d937aaa965e7a7871bbda3490103953a3"
    sha256 cellar: :any, arm64_linux:   "1c688980cf4b0e492a793e5f93889e7038545f888c76c0cba25e17f3b926f02a"
    sha256 cellar: :any, x86_64_linux:  "31dfc31b44268f3eb281f03b785694a3b220d7f1c394d06a5d65cf0fa7b13b6e"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "libnghttp2"
  depends_on "nlohmann-json"
  depends_on "openssl@3"
  depends_on "simdjson"

  on_macos do
    depends_on "llvm"
  end

  on_linux do
    depends_on "gcc"

    fails_with :gcc do
      version "15"
      cause "jaal's C++26 structured binding packs (P1061) require GCC 16 or newer."
    end
  end

  deny_network_access!

  def install
    # Homebrew's dependency provider runs before FetchContent's system-package fallback.
    inreplace "cmake/AgenttySubmodules.cmake",
              "FetchContent_MakeAvailable(nlohmann_json simdjson)", <<~CMAKE
                find_package(nlohmann_json CONFIG REQUIRED)
                find_package(simdjson CONFIG REQUIRED)
    CMAKE
    inreplace "third_party/mcp-cpp/CMakeLists.txt", "FetchContent_MakeAvailable(nlohmann_json)",
              "find_package(nlohmann_json CONFIG REQUIRED)"
    if OS.mac?
      # The linked brewed libc++ supplies facilities absent from older macOS runtimes.
      ENV.llvm_clang
      llvm = Formula["llvm"]
      ENV.append "CXXFLAGS", "-nostdinc++ -isystem #{llvm.opt_include}/c++/v1"
      ENV.append "CXXFLAGS", "-D_LIBCPP_DISABLE_AVAILABILITY" if MacOS.version < :tahoe
      ENV.append "LDFLAGS", "-L#{llvm.opt_lib}/c++ -Wl,-rpath,#{llvm.opt_lib}/c++"
    end

    system "cmake", "-S", ".", "-B", "build", "-G", "Ninja", *std_cmake_args,
           "-DFETCHCONTENT_TRY_FIND_PACKAGE_MODE=ALWAYS",
           "-DFETCHCONTENT_FULLY_DISCONNECTED=ON",
           "-DAGENTTY_USE_MIMALLOC=OFF",
           "-DAGENTTY_BUILD_TESTS=OFF",
           "-DAGENTTY_COMPILER_CACHE=OFF",
           "-DMAYA_NATIVE_TUNING=OFF",
           "-DMAYA_BUILD_EXAMPLES=OFF",
           "-DMAYA_BUILD_TESTS=OFF"
    system "cmake", "--build", "build", "--target", "agentty"
    bin.install "build/agentty"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/agentty --version")
    (testpath/"fixture.txt").write "Homebrew native file tool fixture\n"
    messages = [
      { jsonrpc: "2.0", id: 1, method: "initialize",
        params: { protocolVersion: "2025-11-25", capabilities: {},
                  clientInfo: { name: "homebrew", version: "1.0" } } },
      { jsonrpc: "2.0", method: "notifications/initialized" },
      { jsonrpc: "2.0", id: 2, method: "tools/call",
        params: { name: "read", arguments: { path: (testpath/"fixture.txt").to_s } } },
    ]
    output = pipe_output("#{bin}/agentty mcp-serve 2>#{testpath}/mcp.log",
                         messages.map(&:to_json).join("\n") + "\n", 0)
    responses = output.lines.map { |line| JSON.parse(line) }
    response = responses.find { |entry| entry["id"] == 2 }
    refute_nil response
    result = response.fetch("result")
    refute result["isError"]
    assert_match "Homebrew native file tool fixture", result.fetch("content").first.fetch("text")
  end
end
