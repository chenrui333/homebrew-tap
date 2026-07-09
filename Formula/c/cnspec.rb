class Cnspec < Formula
  desc "Open source, cloud-native security and policy project"
  homepage "https://github.com/mondoohq/cnspec"
  url "https://github.com/mondoohq/cnspec/archive/refs/tags/v13.28.1.tar.gz"
  sha256 "216de75c95e31c9e2a4522239676df94dfb578a5f1517ae4185c4aa67accf23d"
  license "BUSL-1.1"
  head "https://github.com/mondoohq/cnspec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c84190a845851a84c5d2ca301e35b6add229836ac0de810c06d2b97783d47a64"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d74550340dae785fa80c623e5881d5ff9ced5e0283b428112ed517a9068d20f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6279083e9592f8cb16600fd129739063d44af88a9d60cbd2d363a3acb61df165"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "841483d8cd25a5f3ff859ef3be7c956d6c7672957e74af36812c974e649d11d0"
    sha256 cellar: :any,                 x86_64_linux:  "08b06b5508d5feab6b12f9bf29a5996a78781098147ee64e90225bc1018c578f"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X go.mondoo.com/cnspec/v#{version.major}.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./apps/cnspec"

    generate_completions_from_executable(bin/"cnspec", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cnspec version")

    output = shell_output("#{bin}/cnspec policy list 2>&1", 1)
    assert_match "Error: cnspec has no credentials. Log in with `cnspec login`", output
  end
end
