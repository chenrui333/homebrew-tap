class Agentty < Formula
  desc "Terminal AI pair programmer written in modern C++"
  homepage "https://github.com/agentty-org/agentty"
  url "https://github.com/agentty-org/agentty.git",
      tag:      "v0.9.38",
      revision: "8b5494c823962db89a74e4dc974ddf4d63b8f1ca"
  license "MIT"
  head "https://github.com/agentty-org/agentty.git", branch: "master"

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
      # C++23 library facilities must also work with older supported macOS SDKs.
      ENV.llvm_clang
      llvm = Formula["llvm"]
      ENV.append "CXXFLAGS", "-nostdinc++ -isystem #{llvm.opt_include}/c++/v1"
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
