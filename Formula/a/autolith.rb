class Autolith < Formula
  desc "Live, self-modifying Common Lisp coding agent"
  homepage "https://github.com/lambda-symbolics/autolith"
  url "https://github.com/lambda-symbolics/autolith/archive/refs/tags/v0.67.35.tar.gz"
  sha256 "76402ecfdf01ba88271c3cadac27a0b1fff8470686aed97715eab98b3837ac95"
  license "ISC"
  head "https://github.com/lambda-symbolics/autolith.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_tahoe:   "db2e488cb1e2a07fa82f07d9073b4837c4a5ce7ab676a66d7c64406427277724"
    sha256 cellar: :any, arm64_sequoia: "df102a5a8172a87e2b59a374bd473925aa723196c0d554704e74e3d2307b2f9b"
    sha256 cellar: :any, arm64_linux:   "a619348f36f5969c1aae4077545aa7897c67b7808d3f0b86599b45029bb6e194"
    sha256 cellar: :any, x86_64_linux:  "59e5bd631aeabf64d9dd8b5bcd928f3163b32cb6e3014561183fee1f5029acd9"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "sbcl" => :build
  depends_on "bash"
  depends_on "libffi"
  depends_on "libyaml"
  depends_on "onnxruntime"
  depends_on "openssl@3"
  depends_on "perl"

  on_linux do
    depends_on "bubblewrap"
    depends_on "zlib-ng-compat"
  end

  resource "sbcl-source" do
    url "https://downloads.sourceforge.net/project/sbcl/sbcl/2.6.6/sbcl-2.6.6-source.tar.bz2"
    sha256 "a65a7a30812aaf54925d1192b9b9e810f527c79911c6000b7548105aef7da34b"
  end

  resource "qlot" do
    url "https://github.com/fukamachi/qlot/archive/refs/tags/1.8.4.tar.gz"
    sha256 "fcb8d8f1d45a22ea3b81c92be90f85d5cb299faf8faaa94b3dac0684f309a391"
  end

  resource "fff" do
    url "https://github.com/dmtrKovalenko/fff/archive/95fd777c2529fc7b4d7572dabff64cc07268f2c5.tar.gz"
    sha256 "d2d96d7cc472571b23476b502a0b96f974f0e968c0f290b22078cc300bea6c64"
  end

  resource "colorlisp" do
    url "https://github.com/lambda-symbolics/colorlisp/archive/b6fdb68ae22ab997bb818c486983129ec7ac6177.tar.gz"
    sha256 "e13dc0848263a81790eb43702ad7ef6c0865012b7d64d25a97a3ffcaf3d220a0"
  end

  resource "cl-exec-sandbox" do
    url "https://github.com/lambda-symbolics/cl-exec-sandbox/archive/2eee22e33a4d4c6df6019e44ee7fe353454ce175.tar.gz"
    sha256 "77e3883865840313bad276125eb2a5b86c392af47fdb9549edd39261b8fee5e2"
  end

  resource "defingerprinter" do
    url "https://github.com/chakanysystems/defingerprinter/archive/ade272f23397fc1791b5c0a9b1046407cbe39e04.tar.gz"
    sha256 "12a001f6e02498b081c7d2023570189e4fd73d1f242149a6efb26e2a934ed8aa"
  end

  resource "cl-skills" do
    url "https://github.com/lambda-symbolics/cl-skills/archive/21a09a7b7195f6c0e1b36d843c518c5c7bee6ac0.tar.gz"
    sha256 "bb71155afc79a028498e148de21fba8000dba2d54c9a068db417d4e6918dcab4"

    # Keep the executable API's package exports idempotent.
    patch do
      url "https://github.com/lambda-symbolics/cl-skills/commit/48c89e7ce720fccebd776c5984b4b174f18fbd25.patch?full_index=1"
      sha256 "c4a645283c9f21dcdcca44e7644b3de1a98e028ba214173b7b8dd89bf51eabb0"
      type :unofficial
      resolves "https://github.com/lambda-symbolics/cl-skills/pull/3"
    end
  end

  resource "image-daemon" do
    url "https://github.com/lambda-symbolics/image-daemon/archive/fa5a80c0084cf727258d1f937db41cf2ebed2072.tar.gz"
    sha256 "e34884b51baca19fb9a839e7b77fd0087b14aaa9021c1b41da68522abd19dc69"

    # Keep the runtime and message API's package exports idempotent.
    patch do
      url "https://github.com/lambda-symbolics/image-daemon/commit/9ff0a250c8779267b38c9818f4fc0f4eac5522bc.patch?full_index=1"
      sha256 "f8fee9ab7c5b18b6c4cf1e0224b69157c6bd43b01888ef8f75a917bb5e62688d"
      type :unofficial
      resolves "https://github.com/lambda-symbolics/image-daemon/pull/3"
    end
  end

  resource "sbcl-workers" do
    url "https://github.com/lambda-symbolics/sbcl-workers/archive/cded09d0c0d2a3c889f6fbb3414342b957978d74.tar.gz"
    sha256 "d0115a40be7815281f237e27256c336a02aa0d3663549f279411d0a0c70f2258"

    # Keep the host callback API's package exports idempotent.
    patch do
      url "https://github.com/lambda-symbolics/sbcl-workers/commit/89621386f38f34907313ba57f77278d8005b8d37.patch?full_index=1"
      sha256 "47b55cec85442cc109154c7ba1bda17853c278e2c5c52b01aa2a0c27e2a66a69"
      type :unofficial
      resolves "https://github.com/lambda-symbolics/sbcl-workers/pull/3"
    end
  end

  resource "model-config" do
    url "https://huggingface.co/NationalDesignStudio/rampart/resolve/b1993e4e68b082835b80ffc65acc03325ea2e501/config.json"
    sha256 "003b84bbcd489f5e782fe5cad8f3249c3653ec880089abb1ccc398a0d895e3e6"
  end

  resource "model-tokenizer" do
    url "https://huggingface.co/NationalDesignStudio/rampart/resolve/b1993e4e68b082835b80ffc65acc03325ea2e501/tokenizer.json"
    sha256 "98ade711428b42a1b5343c403a73344535e92de8e19359cdb567ef34da210259"
  end

  resource "model-tokenizer-config" do
    url "https://huggingface.co/NationalDesignStudio/rampart/resolve/b1993e4e68b082835b80ffc65acc03325ea2e501/tokenizer_config.json"
    sha256 "0088a6f8bcdd4014184fb068b83ebb12896a9db2bb269a71f73de83fef24bceb"
  end

  resource "model-weights" do
    url "https://huggingface.co/NationalDesignStudio/rampart/resolve/b1993e4e68b082835b80ffc65acc03325ea2e501/onnx/model_q4.onnx"
    sha256 "9f27d24949b0581701071ea5ef522d77ccd3f50c525cc91eac4d265b0fc2afe5"
  end

  # Qlot materializes qlfile.lock's public Lisp sources, and Cargo fetches locked native-library sources.
  allow_network_access! :build

  def install
    pkgshare.install buildpath.children
    runtime = libexec/"runtime"
    ENV.delete "SBCL_HOME"
    resource("sbcl-source").stage do
      # Introspection and recovery need sources matching the private runtime, not the host SBCL.
      # Keep contrib .asd build stubs outside the project's recursive ASDF registry.
      (libexec/"sbcl-source").mkpath
      cp_r Pathname.pwd.children, libexec/"sbcl-source"
      system "sh", "make.sh", "--with-sb-thread", "--prefix=#{runtime}",
                   "--xc-host=#{formula_opt_bin("sbcl")}/sbcl --no-userinit --no-sysinit"
      system "sh", "install.sh", "--prefix=#{runtime}"
    end
    ENV.prepend_path "PATH", runtime/"bin"
    ENV["AUTOLITH_SBCL"] = runtime/"bin/sbcl"
    ENV["AUTOLITH_SBCL_SOURCE_ROOT"] = libexec/"sbcl-source"
    library_paths = %w[libffi libyaml openssl@3].map { |dep| formula_opt_lib(dep) }.join(":")
    ENV[OS.mac? ? "DYLD_FALLBACK_LIBRARY_PATH" : "LD_LIBRARY_PATH"] = library_paths

    resource("cl-exec-sandbox").stage do
      system "bash", "scripts/build-helper"
      libexec.install "build/cl-exec-sandbox-process-group"
      libexec.install "build/cl-exec-sandbox-helper" if OS.linux?
    end
    ENV["CL_EXEC_SANDBOX_PROCESS_GROUP_HELPER"] = libexec/"cl-exec-sandbox-process-group"
    ENV["CL_EXEC_SANDBOX_HELPER"] = libexec/"cl-exec-sandbox-helper" if OS.linux?
    ENV["CL_EXEC_SANDBOX_BWRAP"] = formula_opt_bin("bubblewrap")/"bwrap" if OS.linux?

    resource("colorlisp").stage do
      includes = ["vendor/tree-sitter/include", "vendor/tree-sitter/src", *Dir["vendor/grammars/*/"]]
      sources = ["native/colorlisp-tree-sitter.c", "vendor/tree-sitter/src/lib.c",
                 *Dir.glob("vendor/grammars/**/parser.c", sort: false).sort,
                 *Dir.glob("vendor/grammars/**/scanner.c", sort: false).sort]
      library = shared_library("libcolorlisp-tree-sitter")
      system ENV.cc, (OS.mac? ? "-dynamiclib" : "-shared"), "-fPIC", "-O2", "-std=gnu11",
                    "-fvisibility=hidden", *includes.flat_map { |path| ["-I", path] }, "-o", library, *sources
      libexec.install library
    end
    ENV["COLORLISP_NATIVE_LIBRARY"] = libexec/shared_library("libcolorlisp-tree-sitter")

    resource("fff").stage do
      system "cargo", "build", "--release", "--locked", "--manifest-path", "crates/fff-c/Cargo.toml", "--lib"
      libexec.install "target/release/#{shared_library("libfff_c")}"
    end
    ENV["AUTOLITH_FFF_LIBRARY"] = libexec/shared_library("libfff_c")

    model = pkgshare/"rampart"
    %w[model-config model-tokenizer model-tokenizer-config].each do |name|
      resource(name).stage { model.install Pathname.pwd.children }
    end
    resource("model-weights").stage { (model/"onnx").install Pathname.pwd.children }
    resource("defingerprinter").stage do
      with_env(DEFINGERPRINTER_MODEL_DIR: model,
               DEFINGERPRINTER_RUNTIME:   formula_opt_lib("onnxruntime")/shared_library("libonnxruntime")) do
        system "cargo", "build", "--release", "--locked", "--lib"
      end
      libexec.install "target/release/#{shared_library("libdefingerprinter")}"
      (pkgshare/"defingerprinter").install "LICENSE", "ATTRIBUTION.md", "licenses"
    end
    ENV["AUTOLITH_DEFINGERPRINTER_LIBRARY"] = libexec/shared_library("libdefingerprinter")

    # Materialize Lisp releases in the keg instead of linking the disposable build HOME cache.
    ENV["QLOT_NO_CACHE"] = "1"
    resource("qlot").stage libexec/"qlot"
    system "sh", libexec/"qlot/scripts/setup.sh"
    # Qlot's bootstrap Quicklisp CL+SSL predates OpenSSL 4; select the declared OpenSSL 3 ABI.
    qlot_setup = libexec/"qlot-homebrew-setup.lisp"
    qlot_setup.write <<~LISP
      (load "#{libexec}/qlot/.qlot/setup.lisp")
      (ql:quickload "cl+ssl/config" :silent t)
      (cl+ssl/config:define-libssl-path "#{formula_opt_lib("openssl@3")}/#{shared_library("libssl")}")
      (cl+ssl/config:define-libcrypto-path "#{formula_opt_lib("openssl@3")}/#{shared_library("libcrypto")}")
    LISP
    ENV["QLOT_SETUP_FILE"] = qlot_setup
    cd pkgshare do
      system libexec/"qlot/bin/qlot", "install", "--jobs", "1"
    end
    %w[cl-skills image-daemon sbcl-workers].each do |name|
      destination = pkgshare.glob(".qlot/dists/#{name}/software/*").fetch(0)
      resource(name).stage { cp_r Pathname.pwd.children, destination }
    end
    ENV["ASDF_OUTPUT_TRANSLATIONS"] =
      "(:output-translations (t \"#{pkgshare}/fasls/\") :ignore-inherited-configuration)"
    system runtime/"bin/sbcl", "--noinform", "--no-userinit", "--no-sysinit", "--non-interactive",
           "--load", pkgshare/".qlot/setup.lisp", "--eval", "(require :asdf)",
           "--eval", "(asdf:load-asd #P\"#{pkgshare}/autolith.asd\")",
           "--eval", "(mapc #'asdf:load-system '(:autolith :autolith/structural :autolith/debug))",
           "--eval", "(handler-bind ((warning #'error)) " \
                     "(dolist (entry '((\"cl-skills\" \"src/package.lisp\") " \
                     "(\"image-daemon\" \"src/package.lisp\") (\"sbcl-workers\" \"source/package.lisp\"))) " \
                     "(load (apply #'asdf:system-relative-pathname entry) :verbose nil :print nil)))"

    # Cores are machine-local state: construct and probe them, but never bottle a build-host image.
    images = buildpath/"images"
    system runtime/"bin/sbcl", "--script", pkgshare/"script/build-recovery.lisp",
           images/"recovery/autolith-recovery.core"
    system runtime/"bin/sbcl", "--script", pkgshare/"script/build-active.lisp", images/"active/autolith-active.core"

    (libexec/"materialize-images.pl").write <<~PERL
      use strict;
      use warnings;
      use Fcntl qw(LOCK_EX);
      use File::Path qw(make_path);
      my ($directory, $source, $sbcl) = @ARGV;
      make_path($directory);
      open my $lock, '>>', "$directory/.lock" or die "image lock: $!";
      flock($lock, LOCK_EX) or die "image lock: $!";
      open STDOUT, '>&', STDERR or die "redirect image output: $!";
      for my $kind ('recovery', 'active') {
        my $core = "$directory/$kind/autolith-$kind.core";
        my $probe = $kind eq 'recovery' ? '--probe' : '--autolith-internal-active-image-probe';
        if (-f $core && -f "$directory/$kind/manifest.sexp") {
          next if system($sbcl, '--noinform', '--core', $core, '--end-runtime-options', "$source/", $probe) == 0;
        }
        system($sbcl, '--script', "$source/script/build-$kind.lisp", $core) == 0
          or die "could not construct $kind image";
      }
    PERL
    (bin/"autolith").write <<~SH
      #!/bin/bash
      set -e
      export QLOT_NO_CACHE=1
      export AUTOLITH_SBCL="#{runtime}/bin/sbcl"
      export SBCL_HOME="#{runtime}/lib/sbcl"
      export AUTOLITH_SBCL_SOURCE_ROOT="#{libexec}/sbcl-source"
      export COLORLISP_NATIVE_LIBRARY="#{libexec}/#{shared_library("libcolorlisp-tree-sitter")}"
      export AUTOLITH_FFF_LIBRARY="#{libexec}/#{shared_library("libfff_c")}"
      export AUTOLITH_DEFINGERPRINTER_LIBRARY="#{libexec}/#{shared_library("libdefingerprinter")}"
      export CL_EXEC_SANDBOX_PROCESS_GROUP_HELPER="#{libexec}/cl-exec-sandbox-process-group"
      #{"export CL_EXEC_SANDBOX_HELPER=\"#{libexec}/cl-exec-sandbox-helper\"" if OS.linux?}
      #{"export CL_EXEC_SANDBOX_BWRAP=\"#{formula_opt_bin("bubblewrap")}/bwrap\"" if OS.linux?}
      export #{OS.mac? ? "DYLD_FALLBACK_LIBRARY_PATH" : "LD_LIBRARY_PATH"}="#{library_paths}"
      state="${XDG_DATA_HOME:-$HOME/.local/share}/autolith/homebrew/#{version}"
      mkdir -p "$state/fasls"
      export ASDF_OUTPUT_TRANSLATIONS="(:output-translations (t \\"$state/fasls/\\") :ignore-inherited-configuration)"
      "#{formula_opt_bin("perl")}/perl" "#{libexec}/materialize-images.pl" "$state/images" "#{pkgshare}" "$AUTOLITH_SBCL"
      export AUTOLITH_ACTIVE_CORE="$state/images/active/autolith-active.core"
      export AUTOLITH_RECOVERY_CORE="$state/images/recovery/autolith-recovery.core"
      exec "#{formula_opt_bin("bash")}/bash" "#{pkgshare}/bin/autolith" "$@"
    SH
    chmod 0755, bin/"autolith"
  end

  service do
    run [opt_bin/"autolith", "acp", "--http", "127.0.0.1:8737"]
    log_path var/"log/autolith.log"
    error_log_path var/"log/autolith.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/autolith --version")
    output = shell_output("#{bin}/autolith --pristine models")
    assert_match(/gpt-|claude-|gemini-/, output)
    image_root = testpath/".local/share/autolith/homebrew"/version.to_s/"images"
    assert_path_exists image_root/"active/manifest.sexp"
    assert_path_exists image_root/"recovery/manifest.sexp"
  end
end
