class Cnspec < Formula
  desc "Open source, cloud-native security and policy project"
  homepage "https://github.com/mondoohq/cnspec"
  url "https://github.com/mondoohq/cnspec/archive/refs/tags/v12.19.1.tar.gz"
  sha256 "cafdc6ca88e7f629ae9875175a4037e8172ae63df85bbf3faa2346c6b2a0e4b3"
  license "BUSL-1.1"
  head "https://github.com/mondoohq/cnspec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2cd5edc1474692f93940b7bfd2867f066c1a35fefa6a4d3e8eb70570b85e227f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f60db47025f67435072b561a2e62af9339ee13037b704798f9c43efa75c58f6b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ffbf36bd550d74c7b75f5b10c8b63d42a7b024d5b4c01ff806c57e9c492079e1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b3f4cf212dafd007ff455dbd3d610cb3a891cc90af880b5eed034d165a9b07f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2aa46ad9e43589b1fd47dd79ef406e8766f220de1c7f39d9b8ab8cbce7b553a"
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
