using PyPlot, FourierFlows, QuadGK

 h = 1.0
nx, Lx = 100, 5*h
ny, Ly = 400, 4*h


g = TwoDGrid(nx, Lx, ny, Ly)
x, y = g.x, g.y.';
X, Y = g.X, g.Y;

versions = [
  "Discrete",
  "Continuous"
]

for version in versions
    if version=="Discrete"
        ncontours = 4

        # Couette
        u1(y) = y
        ρ1(y) = 0.0

        # Kelvin-Helmholtz unstratified
        u2(y) = sign(y)
        ρ2(y) = 0.0

        # Kelvin-Helmholtz stratified
        u3(y) =  sign(y)
        ρ3(y) = -sign(y)

        # Rayleigh
        u4(y) = y > h ? 1 : y < -h ? -1 : y
        ρ4(y) = 0.0

        # Taylor
        u5(y) = y
        ρ5(y) = y > h ? -1 : y < -h ? 1 : 0

        # Holmboe
        u6(y) = y > h ? 1 : y < -h ? -1 : y
        ρ6(y) = -sign(y)

    elseif version=="Continuous"

        ncontours = 100
        δ=0.15

        # Couette
        u1(y) = y
        ρ1(y) = 0

        # Kelvin-Helmholtz unstratified
        u2(y) = tanh(y/δ)
        ρ2(y) = 0

        # Kelvin-Helmholtz stratified
        u3(y) =  tanh(y/δ)
        ρ3(y) = -tanh(y/δ)

        # Rayleigh
        function u4(y)
          shear(y) = 0.5*(tanh((y+h)/δ)-tanh((y-h)/δ))
          integ, err = quadgk(shear, -minimum(Y), y; reltol=1e-3)
          integ + 1.0
        end
        ρ4(y) = 0.0

        # Taylor
        u5(y) = y
        ρ5(y) = -0.5*(tanh((y+h)/δ) + tanh((y-h)/δ))

        # Holmboe
        function u6(y)
          shear(y) = 0.5*(tanh((y+h)/δ)-tanh((y-h)/δ))
          integ, err = quadgk(shear, -minimum(Y), y; reltol=1e-3)
          integ + 1.0
        end
        ρ6(y) = -tanh(y/δ)
    end


    fig, axs = subplots(ncols=3, nrows=2, figsize=(12, 8))

    cmap = ColorMap("RdBu_r") #ColorMap("gray")

    sca(axs[1])
    contourf(X, Y, ρ1.(Y), ncontours, cmap=cmap, vmin=-1.5, vmax=1.5)
    plot(u1.(y), y, "k", linewidth=4)
    plot(0*y, y, ":k", linewidth=0.5)
    title("Couette")
    # xlabel(L"u / u_0", fontsize=14)
    ylabel(L"z / h", fontsize=14)

    sca(axs[3])
    contourf(X, Y, ρ2.(Y), cmap=cmap, vmin=-1.5, vmax=1.5)
    plot(u2.(y), y, "k", linewidth=4)
    plot(0*y, y, ":k", linewidth=0.5)
    title(L"Kelvin-Helmholtz")
    # xlabel(L"u / u_0", fontsize=14)
    # ylabel(L"z / h", fontsize=14)

    sca(axs[5])
    contourf(X, Y, ρ3.(Y), ncontours, cmap=cmap, vmin=-1.5, vmax=1.5)
    plot(u3.(y), y, "k", linewidth=4)
    plot(0*y, y, ":k", linewidth=0.5)
    title("Kelvin-Helmholtz stratified")
    # xlabel(L"u / u_0", fontsize=14)
    # ylabel(L"z / h", fontsize=14)

    sca(axs[2])
    contourf(X, Y, ρ4.(Y), ncontours, cmap=cmap, vmin=-1.5, vmax=1.5)
    plot(u4.(y), y, "k", linewidth=4)
    plot(0*y, y, ":k", linewidth=0.5)
    title(L"Rayleigh")
    xlabel(L"u / u_0", fontsize=14)
    ylabel(L"z / h", fontsize=14)

    sca(axs[4])
    contourf(X, Y, ρ5.(Y), ncontours, cmap=cmap, vmin=-1.5, vmax=1.5)
    plot(u5.(y), y, "k", linewidth=4)
    plot(0*y, y, ":k", linewidth=0.5)
    title("Taylor")
    xlabel(L"u / u_0", fontsize=14)
    # ylabel(L"z / h", fontsize=14)

    sca(axs[6])
    contourf(X, Y, ρ6.(Y), ncontours, cmap=cmap, vmin=-1.5, vmax=1.5)
    plot(u6.(y), y, "k", linewidth=4)
    plot(0*y, y, ":k", linewidth=0.5)
    title(L"Holmboe")
    xlabel(L"u / u_0", fontsize=14)
    # ylabel(L"z / h", fontsize=14)

    sca(axs[3])
    if version=="Discrete"
        text(-3, 2.5, "discrete profiles", fontsize=24, fontweight="bold")
    elseif version=="Continuous"
        text(-3, 2.5, "continuous profiles", fontsize=24, fontweight="bold")
    end

    sca(axs[4])
    text(-5.8, -3.1, "shading: density     black curves: zonal flow", fontsize=22)

    savename = string("SimpleProfiles", version)
    savefig(savename, dpi=240)
end
