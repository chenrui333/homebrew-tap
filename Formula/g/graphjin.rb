class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.20.7.tar.gz"
  sha256 "a6b157c32c3704a6388b97d8c8dd6dd5ce9a79f59507bf4ba303b7d8e987fbb5"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4442463be2c242e58f0ff513e5a27560d15b4cb0ee33f94b0b1d7aa73544d47b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c781f88ca6a4c2756db236f6fb22ad81fb0c69de2a8d3f76c96b265b897de18c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "228e9bd8d8b46a361d12b91dcec99c06a9fa08bd3692cab2a3676e868ceacca5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2669f9734c41a4f5c490f921852000cbe8bed60a9a0cdb79a230cf0fc1c18933"
    sha256 cellar: :any,                 x86_64_linux:  "651c64ffbec84a0b31567f0779c97d1234b9a74067f213127b685d293a00e7a3"
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
