class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.18.21.tar.gz"
  sha256 "6722f38e5fcc6f9ee40cc7762c74a66b3c54f76fdab3553d3307b59e622e85e8"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aed4edd2303d3be1280a29b244dfd56b68e52639e98e899be0a59117c316c0b3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5760aea61244a777426c8a704b123d43b4d8fc3eb384c478e4988cbf3756c422"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "61caaa03cf7709ba510dd5d51b4704ca47704389f32c1d4f053d65a40c6bf04b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d972c932737b12cfb8a257a0934b7966869d73e2cb0179bc52c3b151decc5b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d9a24bf1383a4d6a4c1ed1decb07551d091eafced14c1b2f1bc0c10b65e6ee1"
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
