class Cnspec < Formula
  desc "Open source, cloud-native security and policy project"
  homepage "https://github.com/mondoohq/cnspec"
  url "https://github.com/mondoohq/cnspec/archive/refs/tags/v13.2.0.tar.gz"
  sha256 "80df18bad3ac151ed4ce9322ff6959b82de7a79e403d5233ddd43805592ffc48"
  license "BUSL-1.1"
  head "https://github.com/mondoohq/cnspec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1e23372c8da94148bc8a4e595372ca5938ed2a310a1d2abc74a78278ed2a201a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "09ea184d7e1ef5d1ba3cd4703baafeb2bc680848cf3b7c1a230a111ba77ff92c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ab2302b90311906665d586a41836932eebbcf1426762af4412cf652a296e63b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "38d469acf1740f019519f961fbc1f64110a21b3db1f231912d0f6f9e14bc46b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13f5fd084b3d5ffe19a3f28dca49e8d98ead2174d9cffe01e01949464c6c8d38"
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
