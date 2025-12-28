# framework: urfave/cli
class Lintnet < Formula
  desc "General purpose linter for structured configuration data powered by Jsonnet"
  homepage "https://lintnet.github.io/"
  url "https://github.com/lintnet/lintnet/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "c5286cc799333898c1fc74cc27c22a779a6679438fe669351f31236d485e312e"
  license "MIT"
  head "https://github.com/lintnet/lintnet.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "06986cc119c669794b3588ab64edb3d2630330461698afe71f8fb95aa8266e50"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "06986cc119c669794b3588ab64edb3d2630330461698afe71f8fb95aa8266e50"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "06986cc119c669794b3588ab64edb3d2630330461698afe71f8fb95aa8266e50"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3b6be77d2094de45fc580ea291bd9e890167180041d612dbe7a69888b9b16e33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf5cf195825ca510fbdd5a2489186bf1f69524b2a5eed04ce2900c8319d8b1a9"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/lintnet"

    generate_completions_from_executable(bin/"lintnet", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lintnet version")
    assert_match version.to_s, JSON.parse(shell_output("#{bin}/lintnet info"))["version"]

    system bin/"lintnet", "init"
    assert_match "A configuration file of lintnet", (testpath/"lintnet.jsonnet").read
  end
end
