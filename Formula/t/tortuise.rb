class Tortuise < Formula
  desc "Terminal-native 3D Gaussian splatting viewer"
  homepage "https://github.com/buildoak/tortuise"
  url "https://github.com/buildoak/tortuise/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "e48d388823512bdaad4801736e8b9966141dfb2cea353e43f6885e9267377d42"
  license "MIT"
  head "https://github.com/buildoak/tortuise.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "733edededc3fd2e22dbf0c2be55ee25348186c1ae54850239e08f8fb8d30014d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0acdaad66fa8782e8bcb5351ab78ca706651be6b36026aa2239ad7c383f35045"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9423b88cfd6b79de2a9fb848406061e7dc71b7a3ee3f1894101b6f3e784bbc32"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "101e327ed9f3358c78dd8d99ace3ea784bba2e2b9bb5a8152170945265017a42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "845541a99717c926f7717afccf4d32918442122bf5ef55119ce2a483cfd86403"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tortuise --version")

    ENV["TERM"] = "xterm-256color"
    cmd = if OS.mac?
      "printf 'q' | script -q /dev/null #{bin}/tortuise --demo"
    else
      "printf 'q' | script -q -c '#{bin}/tortuise --demo' /dev/null"
    end

    output = shell_output(cmd)
    assert_match(/\e\[\?1049h/, output)
    assert_match(/\e\[\?1049l/, output)
  end
end
