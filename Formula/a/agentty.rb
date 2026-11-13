class Agentty < Formula
  desc "Terminal AI pair programmer written in modern C++"
  homepage "https://github.com/agentty-org/agentty"
  url "https://github.com/agentty-org/agentty.git",
      tag:      "v0.9.56",
      revision: "ef7f30d7c09b4f44ed91ee063dc1fe1b0aed3acc"
  license "MIT"
  head "https://github.com/agentty-org/agentty.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256               arm64_tahoe:   "bbd3d2fee98e2b5b674d629d0a127f2e362bc20ad309ab935e62c694a9697019"
    sha256               arm64_sequoia: "1a6fe672ec3285776e166368deff4bc673ad1d4c987f2684a7fe46b324c29095"
    sha256 cellar: :any, arm64_linux:   "432bd79095b3841788ddd2aa0d6429c4569c055d4413290f4ab178705a4dc80a"
    sha256 cellar: :any, x86_64_linux:  "fedbda9eeb86e4a83a2f43ce653aac63c634c79c4f103a1532e2427421dec94f"
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
