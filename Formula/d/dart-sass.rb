class DartSass < Formula
  desc "Reference implementation of Sass stylesheet compiler"
  homepage "https://sass-lang.com"
  url "https://github.com/sass/dart-sass/archive/refs/tags/1.98.0.tar.gz"
  sha256 "2eab6aebaba4e095e67b970baf8b0bdb4b934be17fdee1ca5d5da6a490b5517a"
  license "MIT"
  head "https://github.com/sass/dart-sass.git", branch: "main"

  depends_on "buf" => :build
  depends_on "dart-sdk" => :build

  resource "language" do
    url "https://github.com/sass/sass.git",
        revision: "cb35c3f36f60be3e1c4bccbae9d6b646e77f4b87"
  end

  def install
    dart = Formula["dart-sdk"].opt_bin/"dart"

    ENV["PUB_ENVIRONMENT"] = "homebrew:dart-sass"

    (buildpath/"build/language").install resource("language")

    system dart, "pub", "get"
    ENV["UPDATE_SASS_PROTOCOL"] = "false"
    system dart, "run", "grinder", "protobuf"
    ENV.delete "UPDATE_SASS_PROTOCOL"

    protocol_version = (buildpath/"build/language/spec/EMBEDDED_PROTOCOL_VERSION").read.strip

    system dart, "compile", "exe",
           "-Dversion=#{version}",
           "-Dcompiler-version=#{version}",
           "-Dprotocol-version=#{protocol_version}",
           "bin/sass.dart", "-o", "sass"

    bin.install "sass"
  end

  test do
    (testpath/"test.scss").write(".class { property: 1 + 1; }\n")
    output = shell_output("#{bin}/sass test.scss")
    assert_match ".class {", output
    assert_match "property: 2;", output
  end
end
