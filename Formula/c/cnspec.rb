class Cnspec < Formula
  desc "Open source, cloud-native security and policy project"
  homepage "https://github.com/mondoohq/cnspec"
  url "https://github.com/mondoohq/cnspec/archive/refs/tags/v13.27.0.tar.gz"
  sha256 "6768473bfcab57e71b48cc7482061e37c62c3189fd84429d1b92d0138ff3eeae"
  license "BUSL-1.1"
  head "https://github.com/mondoohq/cnspec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cb8f0d244270071ae68047c94e9488e0716aaccdd5f87847ee70409bbf092f1d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d21e7004119f077dbf9345dc1ce76e8a5a75694671dc21e8347b76d66baf11a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d8d2203b8a65ec041352bc8170ae6bd4311c440cdab7cea2b1b528deed7929ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "efebed9d79bc8f6bd9a8caf2504a7d8bc9f43a695ee5adcadd65599ee97821d3"
    sha256 cellar: :any,                 x86_64_linux:  "22ce6f3aff84c153b970bbc378be5c9e51f44e8db872f7f241da3b6a31d77299"
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
