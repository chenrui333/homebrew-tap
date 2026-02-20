class Jikkou < Formula
  desc "Resource as code framework for Apache Kafka"
  homepage "https://www.jikkou.io/"
  url "https://github.com/streamthoughts/jikkou/archive/refs/tags/v0.37.2.tar.gz"
  sha256 "cb21ce35699ceabea6d7c728396802742ed5b015b30b8d22b739c27d21c905f4"
  license "Apache-2.0"
  head "https://github.com/streamthoughts/jikkou.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e431158b2d54229d9c8be279467cb204c054b7e6b9c7977d6762d7bd28b0ab37"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b1c73c3204a5b94280d25a3b19f35c146d79e6bcb4461a1c9cc1f16405c53cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c0e0512d307515b14aba2605bf465885bb48615557c00cc4249c7589ec64025"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cd644ed6a9226d2086f0dc77b7ff5079e82f3ba76cc53513a84f0ceba53c49cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "63401236dc800c3d51b63aa6b4d0a3e1427d04f6c7188e533f22d81aef20ee88"
  end

  depends_on "maven" => :build
  depends_on "openjdk"

  def install
    ENV["JAVA_HOME"] = Formula["openjdk"].opt_prefix
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
