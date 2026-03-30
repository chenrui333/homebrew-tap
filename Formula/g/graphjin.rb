class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.14.5.tar.gz"
  sha256 "625e8828a59c269a8e14290aa72d21905bb5b2662c56301a5921fe06f8761a3a"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e714e0721e5f32a8263b41021d1260ea27767cbf651317c5e3871151f15690af"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf93706c6086232da21c95aa602a219bce492f0518b6ce567b8fe4f0335ef665"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "03398e858b94c078f26b1e14fab7e0f864ebce06a8277a927640ec11f2d66d02"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4b5080384189f7d4a0782e81b22ee443d15d9e7692f2e004e734903c5eec3df3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc5a7bbadf899eca95f596010b8e79d960c800ed807f3fbeba0605c6e8fc9d81"
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
