class Cnspec < Formula
  desc "Open source, cloud-native security and policy project"
  homepage "https://github.com/mondoohq/cnspec"
  url "https://github.com/mondoohq/cnspec/archive/refs/tags/v13.27.1.tar.gz"
  sha256 "45ef2944f5dd1c4509db515c4d9bfb7f1b2388d057dca756c85608e22ef787f1"
  license "BUSL-1.1"
  head "https://github.com/mondoohq/cnspec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c5e4ed995696b91173225c519f03daab8ed730c6ef028edc12c181ab15ba757c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf4801f0c5dff6eeabfe5dc96042e1b0008db9211c8574e0fe092c34886280b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "031c216b45e47c26a5257231856351a2cdf9ff0d84ea477dcaa6c5b2d1d2a251"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ed9b88a2598af880cfed6d6bdd84df788866232d6c2b59cd9c95773b8b676026"
    sha256 cellar: :any,                 x86_64_linux:  "647cc3380357126e368d5723fad1386770b3067a69044cbe212ba80fa9bc34b9"
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
