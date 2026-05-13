class Bun < Formula
  desc "Incredibly fast JavaScript runtime, bundler, test runner, and package manager"
  homepage "https://bun.com"
  url "https://github.com/oven-sh/bun.git",
      tag:      "bun-v1.3.14",
      revision: "0d9b296af33f2b851fcbf4df3e9ec89751734ba4"
  license all_of: [
    "MIT",          # Bun itself and most dependencies
    "Apache-2.0",   # boringssl, simdutf, uSockets, and others
    "BSD-3-Clause", # boringssl, lol-html
    "BSD-2-Clause", # libbase64
    "Zlib",         # zlib
  ]
  head "https://github.com/oven-sh/bun.git", branch: "main"

  livecheck do
    url :stable
    regex(/^bun[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "6ddcc50e4aad7157d2a78302f5a0f26fa6ccc97394ac03b6101dfecc8d173909"
    sha256                               arm64_sequoia: "3d5ce085c0f505a7b9b717ae2a49d1215b3d2fce53e99509675b899d91b27402"
    sha256                               arm64_sonoma:  "6ba3a4b52c9b2fa5b123c95f6d9451ab6fcc31d174b5a452c5f464d929e53999"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b3a17f74a94d00372d0d2b177fa5f4d2e5e51207f7baad05883bff14e370e092"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db377c3eb9307024ba39a4d004f00e76930e14c01311563e137c385ea001c8fe"
  end

  depends_on "cmake" => :build
  depends_on "llvm@21" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.12" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "lld@21" => :build
  end

  # Use the official release binary only as a bootstrap compiler for
  # building Bun from source.
  resource "bun-bootstrap" do
    on_macos do
      on_arm do
        url "https://github.com/oven-sh/bun/releases/download/bun-v1.3.11/bun-darwin-aarch64.zip", using: :nounzip
        sha256 "6f5a3467ed9caec4795bf78cd476507d9f870c7d57b86c945fcb338126772ffc"
      end
      on_intel do
        url "https://github.com/oven-sh/bun/releases/download/bun-v1.3.11/bun-darwin-x64.zip", using: :nounzip
        sha256 "c4fe2b9247218b0295f24e895aaec8fee62e74452679a9026b67eacbd611a286"
      end
    end
    on_linux do
      on_arm do
        url "https://github.com/oven-sh/bun/releases/download/bun-v1.3.11/bun-linux-aarch64.zip"
        sha256 "d13944da12a53ecc74bf6a720bd1d04c4555c038dfe422365356a7be47691fdf"
      end
      on_intel do
        url "https://github.com/oven-sh/bun/releases/download/bun-v1.3.11/bun-linux-x64.zip"
        sha256 "8611ba935af886f05a6f38740a15160326c15e5d5d07adef966130b4493607ed"
      end
    end
  end

  def install
    if OS.linux? && ENV["CI"]
      # Linux ARM CI runners are prone to OOM with default parallel build settings.
      if Hardware::CPU.arm?
        ENV.deparallelize
        ENV["CMAKE_BUILD_PARALLEL_LEVEL"] = "1"
      else
        # Keep some parallelism on Linux x86_64 to avoid CI timeouts.
        ENV["CMAKE_BUILD_PARALLEL_LEVEL"] = "2"
      end
    end

    llvm = Formula["llvm@21"]
    ENV.prepend_path "PATH", llvm.opt_bin
    # Bun 1.3.14's build script requires clang >=21.1.0 <21.1.99.
    ENV["CC"] = llvm.opt_bin/"clang"
    ENV["CXX"] = llvm.opt_bin/"clang++"

    if OS.linux?
      ENV.prepend_path "PATH", Formula["lld@21"].opt_bin
      # Highway can emit evex512 ignored-attribute warnings that become errors.
      ENV.append "CXXFLAGS", "-Wno-ignored-attributes"
    end
    if OS.linux? && Hardware::CPU.intel?
      # Keep Linux x86_64 builds off unstable AVX3/AVX512 Highway targets.
      ENV.append "CXXFLAGS",
                 "-DHWY_DISABLED_TARGETS=HWY_AVX3+HWY_AVX3_DL+HWY_AVX3_ZEN4+HWY_AVX3_SPR+HWY_AVX10_2"
    end
    if OS.linux?
      # GCC 12/libstdc++ marks temporary-buffer helpers deprecated and Bun treats
      # warnings as errors in TextCodecCJK.
      ENV.append "CXXFLAGS", "-Wno-error=deprecated-declarations"
    end
    if OS.mac? && MacOS.version <= :sonoma
      # AppleClang on macOS 14 treats unnamed parameters in C stubs as C2x
      # extension warnings, and Bun builds with -Werror.
      ENV.append "CFLAGS", "-Wno-error=c2x-extensions"
    end

    # Some Bun CMake sub-builds fail to auto-detect archive tools under Homebrew
    # superenv and emit CMAKE_AR-NOTFOUND.
    ENV["AR"] = "ar"
    ENV["RANLIB"] = "ranlib"

    resource("bun-bootstrap").stage buildpath/"bootstrap"
    if (bootstrap_zip = Dir[buildpath/"bootstrap"/"*.zip"].first)
      system "unzip", "-q", bootstrap_zip, "-d", buildpath/"bootstrap"
    end
    bootstrap_bin = Dir[buildpath/"bootstrap"/"**/bun"].first
    raise "bootstrap bun binary not found" if bootstrap_bin.nil?

    (buildpath/"bootstrap-bin").mkpath
    cp bootstrap_bin, buildpath/"bootstrap-bin/bun"
    chmod 0755, buildpath/"bootstrap-bin/bun"
    ENV.prepend_path "PATH", buildpath/"bootstrap-bin"

    # Avoid warning-option portability breakages under newer AppleClang/GCC.
    ENV.append "CFLAGS", "-Wno-unknown-warning-option"
    ENV.append "CXXFLAGS", "-Wno-undefined-var-template -Wno-unknown-warning-option"

    if OS.linux?
      # Bun's bun-only warning table injects a plain -Werror, so the formula's
      # Linux CXXFLAGS do not demote this libstdc++ 12 deprecation on their own.
      inreplace "scripts/build/flags.ts",
                '      "-Werror",',
                <<~EOS.chomp
                  "-Werror",
                  "-Wno-error=deprecated-declarations",
                EOS
    end
    # Homebrew packages stable Rust; skip Bun's optional size-only lol-html
    # build-std path, which requires nightly Cargo.
    inreplace "scripts/build/deps/lolhtml.ts",
              <<~OLD,
                const canBuildStdImmediateAbort =
                      cfg.darwin || cfg.freebsd || (cfg.linux && cfg.abi !== "musl" && cfg.abi !== "android");
              OLD
              "const canBuildStdImmediateAbort = cfg.freebsd;"
    if OS.mac? && MacOS.version >= :tahoe
      # The final macOS 26 bun-profile link is getting SIGKILL; skip the large
      # linker map there to keep the Tahoe link step lighter until upstream adjusts.
      inreplace "scripts/build/flags.ts",
                'flag: c => ["-dead_strip", "-dead_strip_dylibs", ' \
                "`-Wl,-map,${c.buildDir}/${bunExeName(c)}.linker-map`],",
                'flag: ["-dead_strip", "-dead_strip_dylibs"],'
    end
    system buildpath/"bootstrap-bin/bun", "run", "build:release"

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
