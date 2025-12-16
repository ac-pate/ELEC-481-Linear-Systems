# ELEC 481 Formula Reference Card - PRINT THIS!
**Keep this beside you while studying**

---

## 🔴 CRITICAL FORMULAS (Memorize First)

### **Controllability Matrix**
```
Cx = [B  AB  A²B  ...  Aⁿ⁻¹B]    (n × np)

System is CONTROLLABLE if rank(Cx) = n
```

### **Observability Matrix**
```
Ox = [C   ]
     [CA  ]     (nq × n)
     [CA² ]
     [ ⋮  ]
     [CAⁿ⁻¹]

System is OBSERVABLE if rank(Ox) = n
```

### **Ackermann's Formula - Controller**
```
K = [0  0  ...  0  1]  ·  Cx⁻¹  ·  φc(A)
    └──────n terms──────┘

Where φc(s) = αₙsⁿ + αₙ₋₁sⁿ⁻¹ + ... + α₁s + α₀

φc(A) = αₙAⁿ + αₙ₋₁Aⁿ⁻¹ + ... + α₁A + α₀I
```

**Example:** For n=2, desired poles at -2, -4:
```
φc(s) = (s+2)(s+4) = s² + 6s + 8
φc(A) = A² + 6A + 8I
K = [0  1] · Cx⁻¹ · φc(A)
```

### **Ackermann's Formula - Observer**
```
G = φe(A)  ·  Ox⁻¹  ·  [0]
                       [0]
                       [⋮]
                       [1]  ← n-th position

Where φe(s) = desired observer characteristic polynomial
```

**Rule of Thumb:** Observer poles should be **2-4× faster** than controller poles!

---

## 🟠 STATE-SPACE REPRESENTATIONS

### **General Form**
```
ẋ = Ax + Bu        (State equation)
y = Cx + Du        (Output equation)

Solution: x(t) = Φ(t-t₀)x(t₀) + ∫[t₀ to t] Φ(t-τ)Bu(τ)dτ
```

### **Controllable Canonical Form (CCF)**
For G(s) = (bₙ₋₁sⁿ⁻¹ + ... + b₁s + b₀) / (sⁿ + aₙ₋₁sⁿ⁻¹ + ... + a₁s + a₀)

```
A = [0      1      0    ...  0   ]
    [0      0      1    ...  0   ]
    [⋮      ⋮      ⋮     ⋱   ⋮   ]
    [0      0      0    ...  1   ]
    [-a₀   -a₁    -a₂   ... -aₙ₋₁]

B = [0]
    [0]
    [⋮]
    [0]
    [1]

C = [b₀  b₁  b₂  ...  bₙ₋₁]

D = [0]  (for strictly proper systems)
```

**Characteristic Polynomial:** det(sI - A) = sⁿ + aₙ₋₁sⁿ⁻¹ + ... + a₁s + a₀

### **Observable Canonical Form (OCF)**
```
A = [0      0      ...  0     -a₀  ]
    [1      0      ...  0     -a₁  ]
    [0      1      ...  0     -a₂  ]
    [⋮      ⋮       ⋱   ⋮      ⋮   ]
    [0      0      ...  1    -aₙ₋₁ ]

B = [b₀]
    [b₁]
    [b₂]
    [⋮ ]
    [bₙ₋₁]

C = [0  0  ...  0  1]

D = [0]
```

### **Jordan Canonical Form (JCF)**
For distinct eigenvalues λ₁, λ₂, ..., λₙ:

```
A = [λ₁   0   ...  0 ]
    [0   λ₂   ...  0 ]
    [⋮    ⋮    ⋱   ⋮ ]
    [0    0   ... λₙ ]

Controllable if all bᵢ ≠ 0
Observable if all cᵢ ≠ 0
```

For repeated eigenvalue λ with multiplicity m:

```
Jordan Block = [λ  1  0  ...  0]
               [0  λ  1  ...  0]
               [⋮  ⋮  ⋮   ⋱   ⋮]
               [0  0  0  ...  1]
               [0  0  0  ...  λ]  (m×m)
```

---

## 🟡 STATE FEEDBACK CONTROL

### **Control Law**
```
u = -Kx    (state feedback)

Closed-loop: Af = A - BK
```

### **Closed-Loop Characteristic Polynomial**
```
det(sI - Af) = det(sI - A + BK) = φc(s)
```

### **Design Steps**
1. Check controllability: rank(Cx) = n?
2. Choose desired poles: λ₁, λ₂, ..., λₙ
3. Form φc(s) = (s - λ₁)(s - λ₂)...(s - λₙ)
4. Apply Ackermann's formula to get K
5. Verify: det(sI - A + BK) = φc(s)

### **For CCF (Direct Method)**
If system already in CCF:
```
Closed-loop char. poly: sⁿ + (aₙ₋₁ + kₙ)sⁿ⁻¹ + ... + (a₁ + k₂)s + (a₀ + k₁)

Match with desired: sⁿ + αₙ₋₁sⁿ⁻¹ + ... + α₁s + α₀

k₁ = α₀ - a₀
k₂ = α₁ - a₁
⋮
kₙ = αₙ₋₁ - aₙ₋₁
```

---

## 🟢 STATE OBSERVERS/ESTIMATORS

### **Full-Order Observer**
```
x̂̇ = Ax̂ + Bu + G(y - Cx̂)
   = (A - GC)x̂ + Bu + Gy

Observer error: e = x - x̂
Error dynamics: ė = (A - GC)e
```

### **Observer Characteristic Polynomial**
```
det(sI - A + GC) = φe(s)

Choose φe(s) such that observer poles are 2-4× faster than controller!
```

### **Combined Controller-Observer**
```
u = -Kx̂  (use estimated states)

x̂̇ = (A - BK - GC)x̂ + Gy
```

### **Separation Principle**
```
Closed-loop char. poly = φc(s) · φe(s)

Controller and observer designs are INDEPENDENT!

Total poles = controller poles + observer poles
```

### **Reduced-Order Observer**
For system with q measured outputs:
```
Observer dimension = n - q

If y = x₁ (first state measured), only estimate x₂, x₃, ..., xₙ
```

---

## 🔵 TRACKING DESIGN

### **Reference Tracking**
```
u = -Kx + Kr·r

Where r = reference input
```

### **Zero Steady-State Error Condition**
```
At steady-state: ẋ∞ = 0

0 = (A - BK)x∞ + BKr·r
y∞ = Cx∞ = r  (want this!)

Solving: Kr = -1 / [C(A - BK)⁻¹B]
```

### **Alternative (DC Gain Method)**
```
For Type 1 system:
Kr = 1 / DC_gain

DC_gain = C·(-Af)⁻¹·B
```

---

## 🟣 POLE-ZERO ASSIGNMENT

### **Closed-Loop Transfer Function**
```
With state feedback u = -Kx + Nr:

Y(s)/R(s) = N·C·(sI - A + BK)⁻¹·B

Poles: Determined by det(sI - A + BK) = 0
Zeros: Determined by K (state feedback adds zeros!)
```

### **Equivalent Loop Gain**
```
For CCF:
Heq(s) = K·adj(sI - A)·B / det(sI - A)

Example: Original G(s) = 100/[s(s+5)]
         With K = [k₁ k₂]:
         GHeq = 100(k₂s + k₁) / [s²(s+5)]

State feedback ADDS ZEROS without adding poles!
```

---

## 🟤 CAYLEY-HAMILTON TECHNIQUE

### **Theorem**
```
If φ(s) = det(sI - A) = sⁿ + αₙ₋₁sⁿ⁻¹ + ... + α₁s + α₀

Then: φ(A) = Aⁿ + αₙ₋₁Aⁿ⁻¹ + ... + α₁A + α₀I = 0

(Matrix satisfies its own characteristic polynomial!)
```

### **Computing Matrix Functions**
To compute f(A) (e.g., A⁻¹, e^(At), sin(A)):

1. Find eigenvalues λ₁, λ₂, ..., λₙ of A
2. Express f(A) = β₀I + β₁A + β₂A² + ... + βₙ₋₁Aⁿ⁻¹
3. Solve: f(λᵢ) = β₀ + β₁λᵢ + β₂λᵢ² + ... + βₙ₋₁λᵢⁿ⁻¹  for i=1,...,n
4. Substitute βᵢ back into f(A)

**For repeated eigenvalue λ with multiplicity m:**
```
f(λ) = β₀ + β₁λ + ... + βₙ₋₁λⁿ⁻¹
f'(λ) = β₁ + 2β₂λ + ... + (n-1)βₙ₋₁λⁿ⁻²
f''(λ) = 2β₂ + 3·2β₃λ + ...
⋮
f^(m-1)(λ) = ...
```

---

## ⚫ STATE TRANSITION MATRIX

### **Definition**
```
For LTI system ẋ = Ax:

Φ(t) = e^(At) = I + At + (At)²/2! + (At)³/3! + ...
```

### **Properties**
```
1. Φ(0) = I
2. Φ(t₁ + t₂) = Φ(t₁)·Φ(t₂)  (semigroup property)
3. Φ⁻¹(t) = Φ(-t)
4. dΦ(t)/dt = A·Φ(t) = Φ(t)·A
```

### **Computing e^(At)**
**Method 1:** Laplace Transform
```
Φ(t) = e^(At) = L⁻¹{(sI - A)⁻¹}
```

**Method 2:** Cayley-Hamilton
```
e^(At) = β₀(t)I + β₁(t)A + ... + βₙ₋₁(t)Aⁿ⁻¹

Solve: e^(λᵢt) = β₀(t) + β₁(t)λᵢ + ... + βₙ₋₁(t)λᵢⁿ⁻¹
```

**Method 3:** Diagonalization (if A has distinct eigenvalues)
```
If A = M·Λ·M⁻¹, then:

e^(At) = M·e^(Λt)·M⁻¹

Where e^(Λt) = [e^(λ₁t)   0      ...   0    ]
                [0      e^(λ₂t)   ...   0    ]
                [⋮        ⋮        ⋱    ⋮    ]
                [0        0      ... e^(λₙt) ]
```

---

## ⚪ COMMON TRANSFORMATIONS

### **CCF ↔ OCF**
```
A_ocf = A_ccf^T
B_ocf = C_ccf^T
C_ocf = B_ccf^T
```

### **Transformation Matrix Properties**
```
If x = Tz:

Anew = T⁻¹AT
Bnew = T⁻¹B
Cnew = CT
Dnew = D  (unchanged)

Transfer function invariant: C(sI-A)⁻¹B = Cnew(sI-Anew)⁻¹Bnew
```

---

## 📊 QUICK REFERENCE TABLE

| **Property**        | **Condition**           | **Implication**          |
|---------------------|-------------------------|--------------------------|
| Controllability     | rank(Cx) = n            | Can place all poles      |
| Observability       | rank(Ox) = n            | Can design observer      |
| Stability           | all Re(λᵢ) < 0          | Bounded response         |
| Asymptotic Stability| all Re(λᵢ) < 0          | x(t) → 0 as t → ∞       |
| Separation Principle| (A,B) controllable      | Controller + Observer    |
|                     | (A,C) observable        | designs independent      |

---

## 🎯 EXAM PROBLEM IDENTIFICATION

| **Problem Phrase**                     | **Topic**              | **Formula**            |
|---------------------------------------|------------------------|------------------------|
| "Place closed-loop poles at..."       | State Feedback         | Ackermann's (K)        |
| "Design observer with poles..."       | Full-Order Observer    | Ackermann's (G)        |
| "Zero steady-state error to step"     | Tracking               | Kr formula             |
| "Some states are measured..."         | Reduced-Order Observer | Partition system       |
| "Add zeros to improve response"       | Pole-Zero Assignment   | State feedback zeros   |
| "Characteristic polynomial is..."     | CCF/OCF                | Read off coefficients  |
| "Transform to controllable form"      | Canonical Transform    | Cx, Tc = Cx·Cx_ccf⁻¹   |

---

## ⏱️ QUICK COMPUTATION SHORTCUTS

### **2×2 Matrix Inverse**
```
If A = [a  b], then A⁻¹ = (1/det) · [ d  -b]
       [c  d]                        [-c   a]

Where det = ad - bc
```

### **2×2 Determinant**
```
det([a  b]) = ad - bc
    [c  d]
```

### **3×3 Determinant (Cofactor Expansion)**
```
det([a  b  c]) = a·det([e  f]) - b·det([d  f]) + c·det([d  e])
    [d  e  f]          [h  i]        [g  i]        [g  h]
    [g  h  i]
```

### **Characteristic Polynomial from Trace & Determinant**
For 2×2 matrix:
```
φ(s) = s² - (trace A)s + det(A)
     = s² - (a₁₁ + a₂₂)s + (a₁₁a₂₂ - a₁₂a₂₁)
```

---

## 🚨 COMMON MISTAKES TO AVOID

1. **Ackermann's formula order:**
   - Controller: `[0 ... 1] · Cx⁻¹ · φc(A)` ✓
   - Observer: `φe(A) · Ox⁻¹ · [0 ... 1]^T` ✓
   - **DON'T MIX THEM UP!**

2. **Observer poles:**
   - Should be **2-4× faster** (more negative)
   - Example: Controller at -2 → Observer at -8 ✓

3. **Characteristic polynomial:**
   - `det(sI - A)` not `det(A - sI)` ✓

4. **Rank check:**
   - Always verify controllability/observability FIRST
   - If not satisfied, design won't work!

5. **Sign convention:**
   - Control: `u = -Kx + Kr·r` (negative feedback!)
   - Observer: `x̂̇ = (A - GC)x̂ + Bu + Gy`

---

## 📝 EXAM CHECKLIST

Before submitting:
- [ ] Did I check controllability/observability?
- [ ] Did I show intermediate matrix computations?
- [ ] Did I verify closed-loop characteristic polynomial?
- [ ] Did I check dimensions (n×n, n×p, q×n)?
- [ ] Did I state assumptions (e.g., "system is controllable")?
- [ ] Did I use correct Ackermann's formula (K vs G)?
- [ ] Did I verify observer poles are faster?
- [ ] Did I show separation principle if applicable?

---

**PRINT THIS PAGE AND KEEP IT BESIDE YOU WHILE SOLVING PROBLEMS!**
