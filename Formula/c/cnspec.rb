class Cnspec < Formula
  desc "Open source, cloud-native security and policy project"
  homepage "https://github.com/mondoohq/cnspec"
  url "https://github.com/mondoohq/cnspec/archive/refs/tags/v13.9.0.tar.gz"
  sha256 "d76cadbc4b87af81ffa281a3d27913abc5bebf3a162b0584b48fb0df4cf28df0"
  license "BUSL-1.1"
  head "https://github.com/mondoohq/cnspec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3ab7eff097de2afbc7319c669b8746aee6d5b168143948e74eb794b10d01ec88"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca5c7594ed58fefdf92b7ca513cd820887e4b70147854f385f79a607a9d65304"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bad7b3a966f219b17a4c32f2bd6573e58cf163239d0e81a30962be3e2c1387ec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "afac7360ec9245d530c4a4bb108a334a8a58c058933c8309227ded1fed57f80a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dda029c23692e22467901048d22bdd97abaf6aef0f050aefd70b3c456582ffbf"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X go.mondoo.com/cnquery/v#{version.major}.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./apps/cnspec"

    generate_completions_from_executable(bin/"cnspec", shell_parameter_format: :cobra)
  end

  test do
    system bin/"cnspec", "version"

    output = shell_output("#{bin}/cnspec policy list 2>&1", 1)
    assert_match "Error: cnspec has no credentials. Log in with `cnspec login`", output
  end
end
