class Bun < Formula
  desc "Incredibly fast JavaScript runtime, bundler, test runner, and package manager"
  homepage "https://bun.com"
  url "https://github.com/oven-sh/bun.git",
      tag:      "bun-v1.3.9",
      revision: "cf6cdbbbadd50604bc17f21ed5d0612c920a5d9a"
  license all_of: [
    "MIT",          # Bun itself and most dependencies
    "Apache-2.0",   # boringssl, simdutf, uSockets, and others
    "BSD-3-Clause", # boringssl, lol-html
    "BSD-2-Clause", # libbase64
    "Zlib",         # zlib
  ]
  head "https://github.com/oven-sh/bun.git", branch: "main"

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.12" => :build
  depends_on "rust" => :build

  on_macos do
    on_sonoma :or_older do
      depends_on "llvm" => :build
    end
  end

  on_linux do
    depends_on "lld" => :build
    depends_on "llvm" => :build
  end

  # Use the official release binary only as a bootstrap compiler for
  # building Bun from source.
  resource "bun-bootstrap" do
    on_macos do
      on_arm do
        url "https://github.com/oven-sh/bun/releases/download/bun-v1.3.9/bun-darwin-aarch64.zip"
        sha256 "cde6a4edf19cf64909158fa5a464a12026fd7f0d79a4a950c10cf0af04266d85"
      end
      on_intel do
        url "https://github.com/oven-sh/bun/releases/download/bun-v1.3.9/bun-darwin-x64.zip"
        sha256 "588f4a48740b9a0c366a00f878810ab3ab5e6734d29b7c3cbdd9484b74a007de"
      end
    end
    on_linux do
      on_arm do
        url "https://github.com/oven-sh/bun/releases/download/bun-v1.3.9/bun-linux-aarch64.zip"
        sha256 "a2c2862bcc1fd1c0b3a8dcdc8c7efb5e2acd871eb20ed2f17617884ede81c844"
      end
      on_intel do
        url "https://github.com/oven-sh/bun/releases/download/bun-v1.3.9/bun-linux-x64.zip"
        sha256 "4680e80e44e32aa718560ceae85d22ecfbf2efb8f3641782e35e4b7efd65a1aa"
      end
    end
  end

  def install
    if OS.linux? && ENV["CI"]
      # Linux CI runners are prone to OOM with default parallel build settings.
      ENV.deparallelize
      ENV["CMAKE_BUILD_PARALLEL_LEVEL"] = "1"
    end

    if OS.linux?
      # Bun's CMake config passes Clang-specific flags that fail with GCC.
      ENV["CC"] = Formula["llvm"].opt_bin/"clang"
      ENV["CXX"] = Formula["llvm"].opt_bin/"clang++"
    end

    # Some Bun CMake sub-builds fail to auto-detect archive tools under Homebrew
    # superenv and emit CMAKE_AR-NOTFOUND.
    ENV["AR"] = "ar"
    ENV["RANLIB"] = "ranlib"

    resource("bun-bootstrap").stage buildpath/"bootstrap"
    bootstrap_bin = Dir[buildpath/"bootstrap"/"**/bun"].first
    raise "bootstrap bun binary not found" if bootstrap_bin.nil?

    (buildpath/"bootstrap-bin").mkpath
    cp bootstrap_bin, buildpath/"bootstrap-bin/bun"
    chmod 0755, buildpath/"bootstrap-bin/bun"
    ENV.prepend_path "PATH", buildpath/"bootstrap-bin"

    # Avoid warning-option portability breakages under newer AppleClang/GCC.
    ENV.append "CFLAGS", "-Wno-unknown-warning-option"
    ENV.append "CXXFLAGS", "-Wno-undefined-var-template -Wno-unknown-warning-option"

    # Bun 1.3.9 defines this dSYM post-build hook with no explicit SOURCES.
    # register_command rejects that, so wire the built bun binary as a source.
    inreplace "cmake/targets/BuildBun.cmake",
              "      TARGET\n        ${bun}\n      TARGET_PHASE\n",
              "      TARGET\n        ${bun}\n      SOURCES\n        ${BUILD_PATH}/${bun}\n      TARGET_PHASE\n"
    # Apple strip lacks Bun's GNU-style options in this block.
    inreplace "cmake/targets/BuildBun.cmake",
              "    set(CMAKE_STRIP_FLAGS --remove-section=__TEXT,__eh_frame " \
              "--remove-section=__TEXT,__unwind_info " \
              "--remove-section=__TEXT,__gcc_except_tab)\n",
              "    set(CMAKE_STRIP_FLAGS)\n"
    inreplace "cmake/targets/BuildBun.cmake",
              "          --strip-all\n          --strip-debug\n          --discard-all\n",
              ""

    # Bun's SetupLLVM helper can append CMAKE_AR/CMAKE_RANLIB with NOTFOUND
    # values, which later surfaces as "CMAKE_AR-NOTFOUND: command not found".
    inreplace "cmake/tools/SetupLLVM.cmake",
              "  find_llvm_command(CMAKE_AR llvm-ar)\n",
              <<~EOS
                find_llvm_command(CMAKE_AR llvm-ar)
                if(CMAKE_AR MATCHES "NOTFOUND")
                  find_command(VARIABLE CMAKE_AR COMMAND ar REQUIRED ON)
                  list(APPEND CMAKE_ARGS -DCMAKE_AR=${CMAKE_AR})
                endif()
              EOS
    inreplace "cmake/tools/SetupLLVM.cmake",
              "  find_llvm_command(CMAKE_RANLIB llvm-ranlib)\n",
              <<~EOS
                find_llvm_command(CMAKE_RANLIB llvm-ranlib)
                if(CMAKE_RANLIB MATCHES "NOTFOUND")
                  find_command(VARIABLE CMAKE_RANLIB COMMAND ranlib REQUIRED ON)
                  list(APPEND CMAKE_ARGS -DCMAKE_RANLIB=${CMAKE_RANLIB})
                endif()
              EOS
    inreplace "cmake/tools/SetupLLVM.cmake",
              "    find_llvm_command(CMAKE_DSYMUTIL dsymutil)\n",
              <<~EOS
                find_llvm_command(CMAKE_DSYMUTIL dsymutil)
                if(CMAKE_DSYMUTIL MATCHES "NOTFOUND")
                  find_command(VARIABLE CMAKE_DSYMUTIL COMMAND dsymutil REQUIRED ON)
                  list(APPEND CMAKE_ARGS -DCMAKE_DSYMUTIL=${CMAKE_DSYMUTIL})
                endif()
              EOS

    system "bun", "run", "build:release"

    bin.install "build/release/bun"
    bin.install_symlink bin/"bun" => "bunx"

    bash_completion.install "completions/bun.bash" => "bun"
    zsh_completion.install "completions/bun.zsh" => "_bun"
    fish_completion.install "completions/bun.fish"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bun --version")

    (testpath/"hello.ts").write <<~TYPESCRIPT
      console.log("Hello world!");
    TYPESCRIPT

    assert_equal "Hello world!", shell_output("#{bin}/bun run hello.ts").chomp
  end
end
