class AwsDoctor < Formula
  desc "Audit AWS security, costs, and best practices"
  homepage "https://awsdoctor.compacompila.com/"
  url "https://github.com/elC0mpa/aws-doctor/archive/refs/tags/v2.6.1.tar.gz"
  sha256 "74c9fc70ef024d6a17b5c563f44d89ca81724cb4f7dec0c5b200541c9374d31f"
  license "MIT"
  head "https://github.com/elC0mpa/aws-doctor.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ea9b9324e721e69bcf2757dacb2b8db6077c024c5f27d92f763105779c5537d3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ea9b9324e721e69bcf2757dacb2b8db6077c024c5f27d92f763105779c5537d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ea9b9324e721e69bcf2757dacb2b8db6077c024c5f27d92f763105779c5537d3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f50797c998d8e757f712abc2c1d9b7d13b204eb92d8a345968a97ad3d084be2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a4e4801792a3cc3c43d403a736a3800282542f33ab174d15affea8fcd7c4e80"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s
      -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "."
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aws-doctor version")
    output = shell_output("#{bin}/aws-doctor --invalid-flag 2>&1", 1)
    assert_match "unknown flag", output
  end
end
