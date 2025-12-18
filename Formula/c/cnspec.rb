class Cnspec < Formula
  desc "Open source, cloud-native security and policy project"
  homepage "https://github.com/mondoohq/cnspec"
  url "https://github.com/mondoohq/cnspec/archive/refs/tags/v12.14.2.tar.gz"
  sha256 "be15308ec9b6bb9510f11a4c8066953e99772b5bf985411d65059af01310a680"
  license "BUSL-1.1"
  head "https://github.com/mondoohq/cnspec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e3086d1149ac5fc6148fa7ea809ca962a3a6e3e2349dc6598e6e0b383daa349d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d16026c677be88ec7eec34a36b479096d7d3737c531ae52da1b6169da6d7ad75"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec23b7ba87ac5aeca8cbde99ae06164f90574b139c1cf337ef22750c4934c3d2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4e6231212cc18355f83e0b6b0a43ed23fc0957da43ef21e02a2a65876545cd1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "559cbcc7f6b62494725eeae9f8c18a3e1db3ed69ce967d23e7bb923ea879973c"
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
