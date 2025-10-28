class Cnspec < Formula
  desc "Open source, cloud-native security and policy project"
  homepage "https://github.com/mondoohq/cnspec"
  url "https://github.com/mondoohq/cnspec/archive/refs/tags/v12.7.0.tar.gz"
  sha256 "caf6bf031dbb0d69fe13f470222c70b31a6ed10af8410fbf859d077f9de74494"
  license "BUSL-1.1"
  head "https://github.com/mondoohq/cnspec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4b1b3206c9c45ed2130c893e1a4df0f9be1826a4912c9d23fecc089a1f7cb828"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2815d7dd6169b6deabbfa26a7f107779dc1dca6693344e6adc2afd27117dd7b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "55552541547ac9032b99aea0bfdc39ef738a1c09007912f384ecbbba03a28c41"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "13e19f85bc0772d0a30d203be5e645ea53b87a29e8615e2fccbb4824a29fa36e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3db6073470793ce72fe152825014431d3c8b5cbaa3ec46a92e5dd72bc6a42ba6"
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
