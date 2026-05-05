class Cnspec < Formula
  desc "Open source, cloud-native security and policy project"
  homepage "https://github.com/mondoohq/cnspec"
  url "https://github.com/mondoohq/cnspec/archive/refs/tags/v13.8.1.tar.gz"
  sha256 "943104fe07598df44e8d0b689509374383cbad51df4359f4e825689207d56b9c"
  license "BUSL-1.1"
  head "https://github.com/mondoohq/cnspec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "21147096cc8d2dc1912d54e2bb403dd980c43555ba3b160606680d41ca30243c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a6f3ebbb03a23ee19d065fec6c5c0c06c0ff37868b2035daae15c75e101c382a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e9e2bcd7f984d8c09ca023264d140455f0c00e03364754c7b5eb06bfe073baf4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e96a52166cae4efa80b4bc6bede579ea95e6bbbd58e255895b71911ec01d3e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba377962759ea8052d8e033095fb5856f741615dea08e6efa1ffc43a6628e2c8"
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
