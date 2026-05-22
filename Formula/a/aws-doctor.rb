class AwsDoctor < Formula
  desc "Audit AWS security, costs, and best practices"
  homepage "https://awsdoctor.compacompila.com/"
  url "https://github.com/elC0mpa/aws-doctor/archive/refs/tags/v2.18.0.tar.gz"
  sha256 "6ceabcdc80eba45d96904a98133796b29939713d1a53cace0e614e6aa69cf0f4"
  license "MIT"
  head "https://github.com/elC0mpa/aws-doctor.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c833a788933cde313714b32f215b974030ea3d4f42c32a1b5ba16eb4b47197b8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c833a788933cde313714b32f215b974030ea3d4f42c32a1b5ba16eb4b47197b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c833a788933cde313714b32f215b974030ea3d4f42c32a1b5ba16eb4b47197b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8ab312e15cff86a609a64e54e57c4133849fc58fe0da8778dd8b4f7f72459245"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "234cc31e9164634f6add8d77e9e9c6780202718c38152d895c023182b7c6ca15"
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
