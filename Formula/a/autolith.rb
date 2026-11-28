class Autolith < Formula
  desc "Live, self-modifying Common Lisp coding agent"
  homepage "https://github.com/lambda-symbolics/autolith"
  url "https://github.com/lambda-symbolics/autolith/archive/refs/tags/v0.67.67.tar.gz"
  sha256 "64e5dd81a8a19eba678b905b7ac7a62fad84c5be5968f4454fb46836e7336264"
  license "ISC"
  head "https://github.com/lambda-symbolics/autolith.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "82c1ce1b1f89f2bce43e8f71c71292f0d618d1a58ca58726ced751805080eb1f"
    sha256 cellar: :any, arm64_tahoe:   "2dd0534f9ec0bef4ef59886bee2430e1170f0e72fbd3fed085d33d3e25771b47"
    sha256 cellar: :any, arm64_sequoia: "6c242782936de7a603567a32093b67a74efd582f62345d4481b44e8028e1a83f"
    sha256 cellar: :any, arm64_linux:   "f5e2ba5b3a717f498a4f0c7997fa9aa3d593ae9fb54d3202335ef2670a643a07"
    sha256 cellar: :any, x86_64_linux:  "3f8e6709f320872a1599f13f7ef70d4b176cf1463a014f289f0fb0a63da1313b"
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
    url "https://github.com/lambda-symbolics/colorlisp/archive/c828aeae0f1bacce0ebe920958474a03042007fc.tar.gz"
    sha256 "5ecdb881ebbbff1d6e9519e0c5411fe7ec6441e09eb8ae5e9ff25d73f173e510"
  end

  resource "cl-exec-sandbox" do
    url "https://github.com/lambda-symbolics/cl-exec-sandbox/archive/5011603d22fc742df0b29aa23d865772803d3d91.tar.gz"
    sha256 "4bbecc91670b8e7196ceb965b3c9af4cde76369564336e0dc84dd93248a37491"
  end

  resource "defingerprinter" do
    url "https://github.com/chakanysystems/defingerprinter/archive/20ff2c26a89ce18fad0dc8bb4fdfd97f3d98327d.tar.gz"
    sha256 "17f1834325496e787c495c9ac186319459dbbb55b0bf474d1edacfa1b9257454"
  end

  resource "cl-skills" do
    url "https://github.com/lambda-symbolics/cl-skills/archive/cd66f1016fb6515d6170ab2e8ca9198a15855d8d.tar.gz"
    sha256 "8126a36820f417cc107fefd067ee749d3943e94c66d2be4e03dfeedbee6df2e2"
  end

  resource "image-daemon" do
    url "https://github.com/lambda-symbolics/image-daemon/archive/52e48c219eb22ca7a3740cb9565ef5cf68c21b6c.tar.gz"
    sha256 "f65167545096a10fdcaf8c1fb082edab512be26e02aeb21ee31c4e494fb1da87"

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
    # Declare this release's optional executable API in DEFPACKAGE so package reloads remain idempotent.
    # Upstream: https://github.com/lambda-symbolics/cl-skills/pull/3
    skills = pkgshare.glob(".qlot/dists/cl-skills/software/*").fetch(0)
    executable = skills/"src/executable.lisp"
    export_form, symbols = executable.read.match(/^\(export '\(([^()]+)\)\)\n/).to_a
    declarations = symbols.split.map { |symbol| "   #:#{symbol}\n" }.join
    inreplace executable, export_form, ""
    inreplace skills/"src/package.lisp", "  (:export\n", "  (:export\n#{declarations}"
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
    library_path_env = OS.mac? ? "DYLD_FALLBACK_LIBRARY_PATH" : "LD_LIBRARY_PATH"
    linux_helpers = if OS.linux?
      <<~ENV_SH.chomp
        export CL_EXEC_SANDBOX_HELPER="#{libexec}/cl-exec-sandbox-helper"
        export CL_EXEC_SANDBOX_BWRAP="#{formula_opt_bin("bubblewrap")}/bwrap"
      ENV_SH
    end
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
      #{linux_helpers}
      export #{library_path_env}="#{library_paths}"
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
