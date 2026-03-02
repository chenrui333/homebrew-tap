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

    # Avoid -Wundefined-var-template failures with current toolchains.
    ENV.append "CXXFLAGS", "-Wno-undefined-var-template"

    # Bun 1.3.9 defines this dSYM post-build hook with no explicit SOURCES.
    # register_command rejects that, so wire the built bun binary as a source.
    inreplace "cmake/targets/BuildBun.cmake",
              "      TARGET\n        ${bun}\n      TARGET_PHASE\n",
              "      TARGET\n        ${bun}\n      SOURCES\n        ${BUILD_PATH}/${bun}\n      TARGET_PHASE\n"

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
