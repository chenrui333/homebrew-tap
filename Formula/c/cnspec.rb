class Cnspec < Formula
  desc "Open source, cloud-native security and policy project"
  homepage "https://github.com/mondoohq/cnspec"
  url "https://github.com/mondoohq/cnspec/archive/refs/tags/v14.11.2.tar.gz"
  sha256 "b101d9c0144d698e3c7fdaa0aa80f014b2849246bddce65630277abb548d32f2"
  license "BUSL-1.1"
  head "https://github.com/mondoohq/cnspec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7e06a6d9abfe01f8aec252b9422b26d6d60413952f864ab02a2d21eb698121cd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d21339f14e2cbaf8f08bfb057db68df1d22dddddb53ef1b39e8a7381534e50ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6356064af87516d908a880cd9e2ecb49590c85359ae452d6ab771fb14e13a5c3"
    sha256 cellar: :any,                 x86_64_linux:  "31a9446693c172f75842d4c87ecc1505b356ca1b243caa79cd9c5979b79e5635"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X go.mondoo.com/cnspec.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./apps/cnspec"

    generate_completions_from_executable(bin/"cnspec", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cnspec --auto-update=false version")

    output = shell_output("#{bin}/cnspec --auto-update=false policy list 2>&1", 1)
    assert_match "Error: cnspec has no credentials. Log in with `cnspec login`", output
  end
end
