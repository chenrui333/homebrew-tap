class Cnspec < Formula
  desc "Open source, cloud-native security and policy project"
  homepage "https://github.com/mondoohq/cnspec"
  url "https://github.com/mondoohq/cnspec/archive/refs/tags/v12.13.2.tar.gz"
  sha256 "8f90b39a8037945c14d8ed4f514715ac6faac5c8d2da1f7ebd242ad71a8c3474"
  license "BUSL-1.1"
  head "https://github.com/mondoohq/cnspec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9f832c08288bc6323efebd512c66aea9a5b52324a5e6fc922bb780ef32ccfd66"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "18dbe3c77236b7e42282c883e48d300a4bfdbf9e800d14d47d4d12510e006d1e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e544cd26b0cdca1e1fd1b36aaddbe9d62129501b121c2ade43c932ade707236e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5740f721268562db506a5f7debd46bed4844e6995eb13c5421674ede4e4bce49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e924d6461fc26204defd565355ade2e60a18a082c9ac5d7318080b63f503c9c"
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
