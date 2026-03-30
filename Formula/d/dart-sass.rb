class DartSass < Formula
  desc "Reference implementation of Sass stylesheet compiler"
  homepage "https://sass-lang.com"
  url "https://github.com/sass/dart-sass/archive/refs/tags/1.98.0.tar.gz"
  sha256 "2eab6aebaba4e095e67b970baf8b0bdb4b934be17fdee1ca5d5da6a490b5517a"
  license "MIT"
  head "https://github.com/sass/dart-sass.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4a4d91c4e6d5786b0e6aa9c60a2839207a40018b651be886539d6d9bf470a4c1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f32b25c7bc2a202fbea56646c247cb5d469ae4188f39a1448a59c17d9233ae55"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "37690ce54457e848239b5660c21591328bfe3224e3d46d62aa8c2de216c1d448"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "313354c1529df8e81a7abcaacfcb4ffb646f9ea70f8965d340cf071bf7e669cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b93ea02faeed968d3fdef57099eb80b08322fd4951de401b52d7dbcee683590c"
  end

  depends_on "buf" => :build
  depends_on "dart-sdk" if OS.linux?
  depends_on "dart-sdk" => :build unless OS.linux?

  resource "language" do
    url "https://github.com/sass/sass.git",
        revision: "cb35c3f36f60be3e1c4bccbae9d6b646e77f4b87"
  end

  def install
    dart = Formula["dart-sdk"].opt_libexec/"bin/dart"

    ENV["PUB_ENVIRONMENT"] = "homebrew:dart-sass"

    (buildpath/"build/language").install resource("language")

    system dart, "pub", "get"
    ENV["UPDATE_SASS_PROTOCOL"] = "false"
    system dart, "run", "grinder", "protobuf"
    ENV.delete "UPDATE_SASS_PROTOCOL"

    protocol_version = (buildpath/"build/language/spec/EMBEDDED_PROTOCOL_VERSION").read.strip
    if OS.linux?
      system dart, "compile", "jit-snapshot",
             "-Dversion=#{version}",
             "-Dcompiler-version=#{version}",
             "-Dprotocol-version=#{protocol_version}",
             "-o", "sass.snapshot",
             "bin/sass.dart", "--version"

      libexec.install "sass.snapshot"

      (bin/"sass").write <<~SH
        #!/bin/sh
        exec "#{Formula["dart-sdk"].opt_libexec}/bin/dart" "#{libexec}/sass.snapshot" "$@"
      SH
      chmod 0555, bin/"sass"
    else
      system dart, "compile", "exe",
             "-Dversion=#{version}",
             "-Dcompiler-version=#{version}",
             "-Dprotocol-version=#{protocol_version}",
             "bin/sass.dart", "-o", "sass"

      bin.install "sass"
    end
  end

  test do
    (testpath/"test.scss").write(".class { property: 1 + 1; }\n")
    output = shell_output("#{bin}/sass test.scss")
    assert_match ".class {", output
    assert_match "property: 2;", output
  end
end
