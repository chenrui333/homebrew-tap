class Zprint < Formula
  desc "Format Clojure and Clojurescript source code and s-expressions"
  homepage "https://github.com/kkinnear/zprint"
  url "https://github.com/kkinnear/zprint/archive/refs/tags/1.2.9.tar.gz"
  sha256 "f765621426c7404b1ada632987890279c38bc8a614f9f61063d68bb06de8a30a"
  license "MIT"

  depends_on "leiningen" => :build
  depends_on "openjdk"

  def install
    system "lein", "uberjar"
    libexec.install Dir["target/*-standalone.jar"].first => "zprint.jar"

    bin.write_jar_script libexec/"zprint.jar", "zprint"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zprint --version")
  end
end
