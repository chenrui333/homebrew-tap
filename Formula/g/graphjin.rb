class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.10.3.tar.gz"
  sha256 "30a1399336a60a0186718a6b9b0d5c59c04ab37daa123828a5062f2c49649ae9"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a0d57649028f8a51851c7b6f3de36338e2c3839c0b9340fc7db08aa274a7205e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5631f4881c7de95c82edc2ebee26ce5e95e01b390a692f55a5eb77a777e77bb1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6e4478dc9bc9a5961458c54ce070284a0c2a64a20979df65f5e87b22d9cb9ca7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b79b96ff35de4dc8cfc458e9e2b1affd5648107520b6f8ae3ef67ca866a3cf94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c2b84a01a9358ac88ada2c097ce840bdf5e416ba017182180d683f3cb0f861d"
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

    system bin/"graphjin", "new", "myapp"
    assert_path_exists testpath/"myapp"
    assert_match "app_name: \"Myapp Development\"", (testpath/"myapp/dev.yml").read
  end
end
