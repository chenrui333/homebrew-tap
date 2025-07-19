# framework: urfave/cli
class Lintnet < Formula
  desc "General purpose linter for structured configuration data powered by Jsonnet"
  homepage "https://lintnet.github.io/"
  url "https://github.com/lintnet/lintnet/archive/refs/tags/v0.4.11-2.tar.gz"
  sha256 "622e80e8af2aafcef8be66823e23b09e748a666d2e73f88f98deb1e26a59863c"
  license "MIT"
  head "https://github.com/lintnet/lintnet.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f86ba27633b7cf321c7bac08e5035a78d5bb022f22753dc56a3e67bd765750a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4634d92873070577bc1a59774b88d5f418cd4aecb952b198f6fac2c0357b26ec"
    sha256 cellar: :any_skip_relocation, ventura:       "8525f1e78b029d696920009b4b62d86dac11fa0f3d9c64554debc06c988f07ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c750aa2350c86068ed8cae3ec1666c63f615aa483d15779239c7e76219671c8"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/lintnet"

    generate_completions_from_executable(bin/"lintnet", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lintnet version")
    assert_match version.to_s, JSON.parse(shell_output("#{bin}/lintnet info"))["version"]

    system bin/"lintnet", "init"
    assert_match "A configuration file of lintnet", (testpath/"lintnet.jsonnet").read
  end
end
