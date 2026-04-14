cask "cc-hdrm" do
  version "1.4.9"
  sha256 "5c2cfb69e19c84f2aab963a47fb37f0e38703ae1d1cc06cd98f46e74ded26ca3"

  url "https://github.com/rajish/cc-hdrm/releases/download/v#{version}/cc-hdrm-#{version}.dmg"
  name "cc-hdrm"
  desc "Menu bar utility showing Claude subscription session headroom"
  homepage "https://github.com/rajish/cc-hdrm"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :sonoma"

  app "cc-hdrm.app"

  zap trash: [
    "~/Library/Application Support/cc-hdrm",
    "~/Library/Caches/com.cc-hdrm.app",
    "~/Library/HTTPStorages/com.cc-hdrm.app",
  ]
end
