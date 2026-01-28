class Cnspec < Formula
  desc "Open source, cloud-native security and policy project"
  homepage "https://github.com/mondoohq/cnspec"
  url "https://github.com/mondoohq/cnspec/archive/refs/tags/v12.20.1.tar.gz"
  sha256 "a1c377591a7ebf4c28bf892168bf4012cfbb8d1543115130750ccd1ff13c4995"
  license "BUSL-1.1"
  head "https://github.com/mondoohq/cnspec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c2c926e988ae006d1e495f62da062dac2e18cafbeb4b84c895aa3cd315e4c834"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "83d77eb70347e7121c4d990d717b463558e24912585a3fb271c684162840ae81"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "79499de70b0e25b6f2b5740a887c7207f1c0e5280221f7e848252dbaa99dad79"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e66cf6c87a1b5176d27266b62c12c7757fda724de1e338020b7b7383b406c9ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "50352358c5e0009845ce00aba6103304d9a0fd295cdb3c89ca13783358a6be5b"
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
