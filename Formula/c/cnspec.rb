class Cnspec < Formula
  desc "Open source, cloud-native security and policy project"
  homepage "https://github.com/mondoohq/cnspec"
  url "https://github.com/mondoohq/cnspec/archive/refs/tags/v13.4.0.tar.gz"
  sha256 "be1ade12a2723df2426e7c367b1f1bb2f6a82a4808871a95676cbc76e9bba8ca"
  license "BUSL-1.1"
  head "https://github.com/mondoohq/cnspec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e42a0c842ab961c9ce4ebef28521f5b57a2447525710b136150d0b32f1c23c4e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "68adc49196093cfbc8def31ead0bc436a5c22cb68c051444f7f57616de98b17a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "15b4c6a925160af56b4143030dea0998c7db67107f7d4ff31798d83780ad2c91"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "692504a6330c4263eb677f46ffc843eda4c3dc28f881a7c8d66e8e516c1453b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e934a094ae3ad4a2c15c16f0500ea208394e10380c42e194cb5f1ed84eff691"
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
