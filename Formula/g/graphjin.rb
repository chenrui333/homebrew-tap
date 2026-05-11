class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.18.17.tar.gz"
  sha256 "b51af2bd6b0258551195fb888f453acec2fa2001aeda0ca5af72bfbc65855aab"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ab3b0c253d72ea825547889e17a63369ac28f100137ac13728880f1ad3f75861"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa00e8d64820f936fbc8f0b45f8646a8ad9b5f83106c8575ff1c8a351117eab4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "251e465e36562bc123bc48ac5c37d5f854dce7ab7c540073135a047b9b629551"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d9748f5bb18c94d3955ac80299aaf40e96aa375da26e8ec2d612b630b4eb0039"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d7c6c2e96e8ff2e73c92e7b6c2e7b480c1b94fca39e0e7c21c5874d72bb6b837"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
      -X github.com/dosco/graphjin/serv/v3.version=#{version}
    ]

    cd "cmd" do
      system "go", "build", *std_go_args(ldflags:)
    end

    generate_completions_from_executable(bin/"graphjin", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/graphjin version")

    system bin/"graphjin", "serve", "new", "myapp"
    assert_path_exists testpath/"myapp"
    assert_match "app_name: \"Myapp Development\"", (testpath/"myapp/dev.yml").read
  end
end
