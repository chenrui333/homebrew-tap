class Cnspec < Formula
  desc "Open source, cloud-native security and policy project"
  homepage "https://github.com/mondoohq/cnspec"
  url "https://github.com/mondoohq/cnspec/archive/refs/tags/v13.3.2.tar.gz"
  sha256 "9b07835797611993ff52332de9e781f2b87a04282a613910bd6cc7f3e615ba12"
  license "BUSL-1.1"
  head "https://github.com/mondoohq/cnspec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6207ed7f84e72ab1163951f3b3a360834fde354f8009798e0273cdcf7b4678d8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a999313dc5bc7c21d7e21e045dba5dbfe67f91030962a94d9bfece9d8f6f157a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb0953cb5e44f995392f0e102a418c2f669a20c994c5ff9e2cada01999e34ba6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f88a70181aeb7962a3a066d74a85722d2e454394acd6fd0b589511cce41822f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "43aa81678cdf6967744f96ed04f8a5d84f6895fc1ffede3f0cfb7c245bf835f4"
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
