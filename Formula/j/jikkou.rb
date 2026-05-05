class Jikkou < Formula
  desc "Resource as code framework for Apache Kafka"
  homepage "https://www.jikkou.io/"
  url "https://github.com/streamthoughts/jikkou/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "bda99c83985d341b06695ea4a7b4cce2b22b662582d1ca01bc018107e179abec"
  license "Apache-2.0"
  head "https://github.com/streamthoughts/jikkou.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f72b841437219c5b6902db74822302534a4ca3352360d352d62b178c1aa3ded1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f72b841437219c5b6902db74822302534a4ca3352360d352d62b178c1aa3ded1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f72b841437219c5b6902db74822302534a4ca3352360d352d62b178c1aa3ded1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0b26d3a9a3fff5bbdb90c81f45a5d5af4ee9301c23e58c91d7b3dd5a5d22a477"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b26d3a9a3fff5bbdb90c81f45a5d5af4ee9301c23e58c91d7b3dd5a5d22a477"
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
