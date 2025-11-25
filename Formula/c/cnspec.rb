class Cnspec < Formula
  desc "Open source, cloud-native security and policy project"
  homepage "https://github.com/mondoohq/cnspec"
  url "https://github.com/mondoohq/cnspec/archive/refs/tags/v12.11.0.tar.gz"
  sha256 "c2618dac423b940904e6470ae113d2802c353739ca4fcec1e4a4b1bccc962abf"
  license "BUSL-1.1"
  head "https://github.com/mondoohq/cnspec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3b9e9230b63cfa8a358e5b3eb714e366a446d60448d79ad15084ca95c3e0a371"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d92c72eebac72ff22df202226c0955e87db25b84f9cee71dcd9344b60c0c0c5e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "221fcb8420df187002ed68c456fcf6281641f03feb7a8444f65777d4b32a4cbc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "23f1b23efe58306df87e17954fd32d5c1b0aed1287c2e94129212476903e9b35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "23c7d96e8f010cdf7ece175d4cba0eb023047c6c27dd357103e8aa854bcd68ca"
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
