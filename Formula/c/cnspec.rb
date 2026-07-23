class Cnspec < Formula
  desc "Open source, cloud-native security and policy project"
  homepage "https://github.com/mondoohq/cnspec"
  url "https://github.com/mondoohq/cnspec/archive/refs/tags/v13.30.1.tar.gz"
  sha256 "bb07d4171b1a9522daf3bc30a6a3b2984ad04d4b83a1f57c494c2609ed8b282b"
  license "BUSL-1.1"
  head "https://github.com/mondoohq/cnspec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "48511ff53fa3a129512d18146bc60a76b8f10fdd387ca144cd446fdc4387470e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "da4a30548059661fea5a8b13574c602a1c74b05e49ed4f1ca7cca31267bf6af8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "73205bd38694752f973aea938c8d6b68fd98979d9406837a8c83b4c20b06078e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b129064fd6ebe6548acf220d508752203f28607168e02b6327de519847cb2f8d"
    sha256 cellar: :any,                 x86_64_linux:  "2f603d89ca23a60555c5d633102d3127e9dcb3392f9218678336e51f1ef26eb6"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X go.mondoo.com/cnspec/v#{version.major}.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./apps/cnspec"

    generate_completions_from_executable(bin/"cnspec", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cnspec version")

    output = shell_output("#{bin}/cnspec policy list 2>&1", 1)
    assert_match "Error: cnspec has no credentials. Log in with `cnspec login`", output
  end
end
