class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.15.1.tar.gz"
  sha256 "f692d5d4ef039321e77957fccc14eafda46909e71bc782623b3b5929c7fd6c28"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bb5c51ec018a001ab46d777b1ac5c20396537fac5b9ef6f127a25e49b3f7c2dc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dba8cac831ee9ec6c1fc2355d2b08541b0ad0bdc2dfc90afaf902ca9f48c2dce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f6440e7a2cc905c084b9f94e457df92b54680595d51f786a560ebcdc9169621b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "84b386807c2207fde53202fc70f4677ba6a77b87a9c8a113a8c7d5d84121e2f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b290db7233171580d924e63fa126ac9299d9bcfc3aab4046a30c73b0f940e75"
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
