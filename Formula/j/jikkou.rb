class Jikkou < Formula
  desc "Resource as code framework for Apache Kafka"
  homepage "https://www.jikkou.io/"
  url "https://github.com/streamthoughts/jikkou/archive/refs/tags/v0.37.2.tar.gz"
  sha256 "cb21ce35699ceabea6d7c728396802742ed5b015b30b8d22b739c27d21c905f4"
  license "Apache-2.0"
  head "https://github.com/streamthoughts/jikkou.git", branch: "main"

  depends_on "maven" => :build
  depends_on "openjdk"

  def install
    ENV["JAVA_HOME"] = Formula["openjdk"].opt_libexec/"openjdk.jdk/Contents/Home"
    ENV.prepend_path "PATH", Formula["openjdk"].opt_bin

    system "mvn", "-ntp", "-B", "-pl", "cli", "-am", "package", "-DskipTests"

    libexec.install "cli/target/jikkou-cli-#{version}-runner.jar" => "jikkou.jar"
    bin.write_jar_script libexec/"jikkou.jar", "jikkou", java_version: "25"

    bash_completion.install "jikkou_completion" => "jikkou"
  end

  test do
    output = shell_output("#{bin}/jikkou --version")
    assert_match "Jikkou version \"#{version}\"", output

    completion = shell_output("#{bin}/jikkou generate-completion")
    assert_match "_picocli_jikkou", completion
  end
end
