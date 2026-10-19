class Cnspec < Formula
  desc "Open source, cloud-native security and policy project"
  homepage "https://github.com/mondoohq/cnspec"
  url "https://github.com/mondoohq/cnspec/archive/refs/tags/v14.7.1.tar.gz"
  sha256 "9b482a469652731532a375dfad1e5493f8809b5318dba98762e530fa4df79f4c"
  license "BUSL-1.1"
  head "https://github.com/mondoohq/cnspec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "138aaea785701fd430cb429e513971730c0ec7ddcbf79d60931258ed5fafb1c8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d13f1fa31b2c1d7bdc32d9aee18c7471e588df26057432ff5b6547b93f3cabd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d04b0923679af5f4c966b63f7bb124af112c3d77c037a394a69dab452a42a55b"
    sha256 cellar: :any,                 x86_64_linux:  "dedfd40305b1baff300811e547ca6776e5055ae4f1f0034af8c0e135264ba05d"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-s -w -X go.mondoo.com/cnspec.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./apps/cnspec"

    generate_completions_from_executable(bin/"cnspec", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cnspec version")

    output = shell_output("#{bin}/cnspec policy list 2>&1", 1)
    assert_match "Error: cnspec has no credentials. Log in with `cnspec login`", output
  end
end
