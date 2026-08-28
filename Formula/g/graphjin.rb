class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.20.65.tar.gz"
  sha256 "cf2dfcc3cb4bd8b318e3e0e23525b07e9b36e662215f180cc285cc489fae637c"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ff31c4162e52554ca9751a10659ed68af1eb4f2e2a715e0d2953ca145906cf5a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3eb4a598ea2585f3bb5e06b743b68c23e256f3160e5608acad8b2b08b14b2e42"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91f34b90acc302610eb1aed309fec15f0c9a2acef6ea37ce2a143884f1b78b30"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "265b38b499be8ddaee22825ab2fa725cb863da7dae4fc0670684ba6b6dde4395"
    sha256 cellar: :any,                 x86_64_linux:  "a4b4e92a0c5f4df1a13badc61c8ed997cc3ce2bf79ca1a59ba8b7a80ac672399"
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
