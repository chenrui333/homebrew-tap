class Cnspec < Formula
  desc "Open source, cloud-native security and policy project"
  homepage "https://github.com/mondoohq/cnspec"
  url "https://github.com/mondoohq/cnspec/archive/refs/tags/v12.11.0.tar.gz"
  sha256 "c2618dac423b940904e6470ae113d2802c353739ca4fcec1e4a4b1bccc962abf"
  license "BUSL-1.1"
  head "https://github.com/mondoohq/cnspec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "25ffeabdf42b717c9d345c12372bc868cf97af79e1fb1fca9cd9edda3bf00ebd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ac308c89638fdfaf4c1a228d7d3d901382fa7b25be6583b61d8d942047b1b7dc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9752676b8e00c095601ec089ffc595a2cbc71c6faaa755848e3dd4f5a5cd6a20"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "60447be755e305d0b554f7888ee7def878f1faedf9ea30201f24e99d0d747a49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "21df520e1a2d48a8a37dfa2ec6fd4c6de4ab661b39931f73fa197536b7fe5997"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X go.mondoo.com/cnquery/v#{version.major}.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./apps/cnspec"

    generate_completions_from_executable(bin/"cnspec", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    system bin/"cnspec", "version"

    output = shell_output("#{bin}/cnspec policy list 2>&1", 1)
    assert_match "Error: cnspec has no credentials. Log in with `cnspec login`", output
  end
end
