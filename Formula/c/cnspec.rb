class Cnspec < Formula
  desc "Open source, cloud-native security and policy project"
  homepage "https://github.com/mondoohq/cnspec"
  url "https://github.com/mondoohq/cnspec/archive/refs/tags/v13.3.4.tar.gz"
  sha256 "c93e91d10c77f7734a0db14431d96051d9125b51d7371441df3bdcbf0603fa17"
  license "BUSL-1.1"
  head "https://github.com/mondoohq/cnspec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5283940b5df28436f18f1665ed49cd97062825cceda20c165ffd75086f967659"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "40060b8449497e2266be0f75e6cf5ab7e4d1387578205e94ce7b85b339c3a7b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0465f56a3f0bae8e9a50e2a8efa85f85c2c3935ac659dd425e97e4edd8a1bf15"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4d9c9e76f6aca1a20891bd449b3e4425d8bb5cecbde90af9e6d013aaa85d8607"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75ac752514d1dda36bcd492f0d4753a0cd85eb68a2bd93dc901f858a4742c7ac"
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
