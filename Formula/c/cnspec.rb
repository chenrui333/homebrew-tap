class Cnspec < Formula
  desc "Open source, cloud-native security and policy project"
  homepage "https://github.com/mondoohq/cnspec"
  url "https://github.com/mondoohq/cnspec/archive/refs/tags/v12.19.0.tar.gz"
  sha256 "01d7ca2d5ac2e831dc9d0e5f1888d261f4f23d6d7f9b75f62c5689e5bfc0fc06"
  license "BUSL-1.1"
  head "https://github.com/mondoohq/cnspec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0d01c38defda2b6df959530dae820b184a425e515c8d9dd91490459aa99bc699"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ade1803904c20e86607a6e9959d7d8960bd6785da1bf6c2fa04773a515e7ea39"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "df3379f380ab03f5f1e0b40cb263f6a250d9245d690394c1eb059fe8c6ea32d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7d4bd59b98de28dccc2c667bac21e63bfa5b75b6b9c4a52c415c5257c8b121f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0bbaf40f49854eae5ec766d9f454b76bd9b23199a0541dde174fae7509eb416"
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
