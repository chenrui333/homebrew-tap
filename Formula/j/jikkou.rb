class Jikkou < Formula
  desc "Resource as code framework for Apache Kafka"
  homepage "https://www.jikkou.io/"
  url "https://github.com/streamthoughts/jikkou/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "bda99c83985d341b06695ea4a7b4cce2b22b662582d1ca01bc018107e179abec"
  license "Apache-2.0"
  head "https://github.com/streamthoughts/jikkou.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2be4f91311992112de9c45f96d7f5367e0a37bdcc8c76be632ae4fc03e505350"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2be4f91311992112de9c45f96d7f5367e0a37bdcc8c76be632ae4fc03e505350"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2f6c31d57b136b5ec37fdeae9699e1b8db584716155c6d7478e1bfada4b55007"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f6c31d57b136b5ec37fdeae9699e1b8db584716155c6d7478e1bfada4b55007"
  end

  depends_on "maven" => :build
  # Lombok in v1.0.0 fails under JDK 27 (javac EndPosTable ExceptionInInitializerError).
  depends_on "openjdk@25"

  # Maven/Quarkus resolves plugins and deployment artifacts during packaging; go-offline does not cover them.
  allow_network_access! :build

  def install
    ENV["JAVA_HOME"] = formula_opt_prefix("openjdk@25")
    ENV.prepend_path "PATH", formula_opt_bin("openjdk@25")

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
