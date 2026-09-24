class Kythe < Formula
  desc "Pluggable ecosystem for building tools that work with code"
  homepage "https://kythe.io/"
  url "https://github.com/kythe/kythe/archive/refs/tags/v0.0.76.tar.gz"
  sha256 "1227aa502bd4ded73a89fcef03830a35d9512635e9791e8f5390d1899962aa87"
  license "Apache-2.0"
  head "https://github.com/kythe/kythe.git", branch: "master"

  depends_on "asciidoc" => :build
  depends_on "bazelisk" => :build
  depends_on "bison" => :build
  depends_on "flex" => :build
  depends_on "gnu-sed" => :build
  depends_on "graphviz" => :build
  depends_on "m4" => :build
  depends_on "pkgconf" => :build
  depends_on "ruby" => :build
  depends_on "source-highlight" => :build
  depends_on "zip" => :build
  depends_on "openjdk@21"

  on_linux do
    depends_on "util-linux" # for libuuid
  end

  def install
    java_home = formula_opt_libexec("openjdk@21")
    java_home /= "openjdk.jdk/Contents/Home" if OS.mac?
    ENV["JAVA_HOME"] = java_home
    ENV.prepend_path "PATH", formula_opt_bin("openjdk@21")

    %w[asciidoc bazelisk bison flex graphviz source-highlight zip].each do |tool|
      ENV.prepend_path "PATH", formula_opt_bin(tool)
    end
    ENV.prepend_path "PATH", formula_opt_libexec("gnu-sed")/"gnubin"
    ENV.prepend_path "PATH", formula_opt_bin("util-linux") if OS.linux?

    if OS.mac?
      ENV["CC"] = which("clang", "/usr/bin")
      ENV["CXX"] = which("clang++", "/usr/bin")

      # macOS does not support fully static user binaries.
      inreplace "kythe/go/extractors/cmd/bazel/bazel_go_extractor/BUILD", 'static = "on"', 'static = "off"'
    end

    bazel_path = ENV.fetch("PATH")
    if OS.linux?
      bazel_path = bazel_path.split(File::PATH_SEPARATOR)
                             .reject { |path| path.include?("/Homebrew/shims/") }
                             .join(File::PATH_SEPARATOR)

      inreplace "kythe/cxx/indexer/cxx/GraphObserver.h" do |s|
        s.gsub!("return kNullClaimTokenClass;", "return ClassToken();") ||
          raise("NullClaimToken ID invocation not found")

        old_definition = <<~CPP
          static inline const uintptr_t kNullClaimTokenClass =
                  reinterpret_cast<uintptr_t>(&kNullClaimTokenClass);
        CPP
        new_definition = <<~CPP
          static uintptr_t ClassToken() {
            static const char token = 0;
            return reinterpret_cast<uintptr_t>(&token);
          }
        CPP
        s.gsub!(old_definition, new_definition) || raise("NullClaimToken ID definition not found")
      end
    end
    # GCC cannot deduce a common type for DirectoryEntryRef and nullptr here.
    inreplace "kythe/cxx/extractor/cxx_extractor.cc" do |s|
      old = "const auto current_file_parent_entry = file_or ? file_or->getDir() : nullptr;"
      new = "const std::optional<clang::DirectoryEntryRef> current_file_parent_entry =\n      " \
            "file_or ? std::make_optional(file_or->getDir()) : std::nullopt;"
      s.gsub!(old, new) || raise("DirectoryEntryRef optional conversion not found")
      old = "*search_path_entry == current_file_parent_entry"
      new = "current_file_parent_entry && *search_path_entry == *current_file_parent_entry"
      s.gsub!(old, new) || raise("DirectoryEntryRef optional comparison not found")
    end

    bazel_args = [
      "--repo_env=PATH=#{bazel_path}",
      "--action_env=PATH=#{bazel_path}",
      "--tool_java_runtime_version=local_jdk",
      "--extra_toolchains=@local_jdk//:all",
    ]
    if OS.linux?
      bazel_args.push(
        "--copt=-D_Nullable=",
        "--copt=-D_Nonnull=",
        "--copt=-Wno-complain-wrong-lang",
        "--copt=-Wno-changes-meaning",
      )
    end
    system "bazelisk", "--batch", "build", *bazel_args, "//kythe/release"

    archive = Dir["bazel-bin/kythe/release/kythe-v*.tar.gz"].fetch(0)
    libexec.mkpath
    system "tar", "-xzf", archive, "-C", libexec, "--strip-components=1"

    %w[extractors indexers tools].each do |dir|
      (libexec/dir).children.select { |path| path.file? && File.executable?(path) }.each do |path|
        bin.install_symlink path
      end
    end

    {
      "bazel_java_extractor" => "extractors/bazel_java_extractor.jar",
      "bazel_jvm_extractor"  => "extractors/bazel_jvm_extractor.jar",
      "javac_extractor"      => "extractors/javac_extractor.jar",
      "java_indexer"         => "indexers/java_indexer.jar",
      "jvm_indexer"          => "indexers/jvm_indexer.jar",
    }.each do |name, jar|
      bin.write_jar_script(libexec/jar, name, java_version: "21")
    end
  end

  test do
    # FIXME: Upstream commands do not expose a version option.
    source = testpath/"example.go"
    source.write("package example\n")
    archive = testpath/"example.kzip"
    system bin/"kzip", "create", "-output", archive, "-uri", "kythe://example?lang=go", "-source_file", source

    output = shell_output("#{bin}/kzip info --input #{archive}")
    assert_match '"corpora":{"example":', output
    assert_match(/"size":"[1-9][0-9]*"/, output)
  end
end
